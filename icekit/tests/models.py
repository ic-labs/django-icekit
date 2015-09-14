"""
Test models for ``icekit`` app.
"""

from icekit import abstract_models


class BaseModel(abstract_models.AbstractBaseModel):
    """
    Concrete base model.
    """
    pass


class FooWithLayout(abstract_models.LayoutFieldMixin):
    pass


class BarWithLayout(abstract_models.LayoutFieldMixin):
    pass


class BazWithLayout(abstract_models.LayoutFieldMixin):
    pass
