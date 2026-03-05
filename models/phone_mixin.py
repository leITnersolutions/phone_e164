import phonenumbers
import logging
from odoo import models

_logger = logging.getLogger(__name__)


class PhoneMixin(models.AbstractModel):
    """
    Override phone_format to always store numbers in pure E.164 format
    (e.g. +4312345678) without spaces or formatting characters.

    This is required for Vodia PBX CRM connector, which does an exact
    string match against phone/mobile fields.
    """
    _inherit = 'phone.mixin'

    def _phone_format(self, number, country=None, company=None):
        """
        Override: format phone numbers as E.164 (no spaces, no dashes).
        Falls back to the original value if parsing fails.
        """
        if not number:
            return number

        # Determine country code for parsing
        country_code = None
        if country:
            country_code = country.code
        elif self and hasattr(self, 'country_id') and self.country_id:
            country_code = self.country_id.code
        elif company and hasattr(company, 'country_id') and company.country_id:
            country_code = company.country_id.code

        try:
            phone_nbr = phonenumbers.parse(number, country_code)
            if phonenumbers.is_valid_number(phone_nbr):
                return phonenumbers.format_number(
                    phone_nbr,
                    phonenumbers.PhoneNumberFormat.E164
                )
            else:
                _logger.debug(
                    "phone_e164: '%s' parsed but not valid, keeping original.", number
                )
        except phonenumbers.NumberParseException:
            _logger.debug(
                "phone_e164: could not parse '%s', keeping original.", number
            )

        return number
