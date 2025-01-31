from django.db import models
import uuid

class Brand(models.Model):
    brand_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    brand_name = models.CharField(max_length=50)
    brand_location = models.CharField(max_length=50, blank=True, null=True)
    brand_official_phone = models.CharField(max_length=15, blank=True, null=True)

    class Meta:
        db_table = 'brand'


class Customer(models.Model):
    customer_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    address = models.CharField(max_length=250)
    phone_no = models.CharField(max_length=15, blank=True, null=True)
    pincode = models.CharField(max_length=6)  # Pincode should be a CharField
    age = models.IntegerField()  # Age should be an IntegerField
    gender = models.CharField(max_length=7, blank=True, null=True)
    doctor = models.ForeignKey('DoctorConsultation', on_delete=models.SET_NULL, blank=True, null=True)

    class Meta:
        db_table = 'customer'


class DoctorConsultation(models.Model):
    doctor_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    doctor_name = models.CharField(max_length=50)
    doctor_address = models.CharField(max_length=250, blank=True, null=True)
    doctor_phone_no = models.CharField(max_length=15, blank=True, null=True)
    doctor_qualification = models.CharField(max_length=100)
    doctor_specialization = models.CharField(max_length=25)

    class Meta:
        db_table = 'doctor_consultation'


class MedicineShop(models.Model):
    shop_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    shop_name = models.CharField(max_length=100)
    shop_address = models.CharField(max_length=250)
    shop_phone_no = models.CharField(max_length=15, blank=True, null=True)

    class Meta:
        db_table = 'medicine_shop'


class Product(models.Model):
    product_id = models.BigAutoField(primary_key=True)
    product_name = models.CharField(max_length=100)
    product_type = models.CharField(max_length=25)
    product_quantity = models.CharField(max_length=20)
    product_based_on_gender = models.CharField(max_length=7, blank=True, null=True)
    product_age_group = models.CharField(max_length=20, blank=True, null=True)
    product_price = models.DecimalField(max_digits=10, decimal_places=2)
    product_commission_percent = models.DecimalField(max_digits=5, decimal_places=2)
    product_mfg_date = models.DateField(blank=True, null=True)
    product_exp_date = models.DateField(blank=True, null=True)
    product_shop = models.ForeignKey(MedicineShop, on_delete=models.CASCADE)
    product_brand = models.ForeignKey(Brand, on_delete=models.CASCADE, null=True, blank=True)


    class Meta:
        db_table = 'product'


class Cart(models.Model):
    cart_id = models.BigAutoField(primary_key=True)
    customer = models.OneToOneField(Customer, on_delete=models.CASCADE)
    delivery_time = models.TimeField(blank=True, null=True)

    class Meta:
        db_table = 'cart'


class CartItems(models.Model):
    id = models.AutoField(primary_key=True)  # Explicitly defining a primary key
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField()

    class Meta:
        db_table = 'cart_items'
        unique_together = (('cart', 'product'),)


class Wishlist(models.Model):
    id = models.AutoField(primary_key=True)  # Explicitly defining a primary key
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    class Meta:
        db_table = 'wishlist'
        unique_together = (('customer', 'product'),)


class Payment(models.Model):
    PAYMENT_METHODS = [
        ('CASH ON DELIVERY', 'Cash on Delivery'),
        ('CREDIT/DEBIT CARD', 'Credit/Debit Card'),
        ('E-WALLETS', 'E-Wallets'),
        ('NETBANKING', 'Netbanking'),
    ]
    PAYMENT_STATUSES = [
        ('PENDING', 'Pending'),
        ('COMPLETED', 'Completed'),
        ('FAILED', 'Failed'),
    ]

    payment_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    transaction_id = models.CharField(unique=True, max_length=50)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=50, choices=PAYMENT_METHODS)
    payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUSES)
    payment_date = models.DateTimeField(blank=True, null=True)
    coupon_applied = models.BooleanField()
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)

    class Meta:
        db_table = 'payment'
