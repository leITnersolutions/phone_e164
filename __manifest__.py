{
    'name': 'Phone E.164 Format (No Spaces)',
    'version': '19.0.1.0.0',
    'summary': 'Stores phone numbers in E.164 format without spaces for Vodia compatibility',
    'description': """
        Overrides Odoo's default phone formatting (INTERNATIONAL with spaces)
        to use pure E.164 format (+43123456789) without any spaces.
        Required for Vodia PBX CRM connector to match caller IDs correctly.
    """,
    'author': 'Custom',
    'category': 'Tools',
    'depends': ['phone_validation'],
    'data': [],
    'installable': True,
    'auto_install': False,
    'license': 'LGPL-3',
}
