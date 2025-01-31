from django.contrib import admin
from .models import (
    Customer,
    Product,
    MedicineShop,
    DoctorConsultation,
    Payment,
    Brand,
    Cart,
    CartItems,
    Wishlist,
)

admin.site.register(Customer)
admin.site.register(Product)
admin.site.register(DoctorConsultation)
admin.site.register(MedicineShop)
admin.site.register(Payment)
admin.site.register(Brand)
admin.site.register(Cart)
admin.site.register(CartItems)
admin.site.register(Wishlist)
