List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID"
  },
  {
    "key": "stay_duration_day",
    "type": "number",
    "title": "Stay (Days)"
  },
  {
    "key": "stay_duration_hour",
    "type": "number",
    "title": "Stay (Hours)"
  },
  {
    "key": "number_of_guests",
    "type": "number",
    "title": "Number of Guests"
  },
  {
    "key": "schedule_check_out",
    "type": "date-time",
    "title": "Schedule Check-out"
  },
  {
    "key": "room_revenue_usd",
    "type": "number",
    "title": "Room Revenue (USD)"
  },
  {
    "key": "price_total_usd",
    "type": "number",
    "title": "Total Price (USD)"
  },
  {
    "key": "paid_bank_usd",
    "type": "number",
    "title": "Paid Bank (USD)"
  },
  {
    "key": "paid_bank_khr",
    "type": "number",
    "title": "Paid Bank (KHR)"
  },
  {
    "key": "paid_cash_usd",
    "type": "number",
    "title": "Paid Cash (USD)"
  },
  {
    "key": "paid_cash_khr",
    "type": "number",
    "title": "Paid Cash (KHR)"
  },
  {
    "key": "paid_total_usd",
    "type": "number",
    "title": "Total Paid (USD)"
  },
  {
    "key": "return_usd",
    "type": "number",
    "title": "Return (USD)"
  },
  {
    "key": "return_khr",
    "type": "number",
    "title": "Return (KHR)"
  },
  {
    "key": "return_total_usd",
    "type": "number",
    "title": "Total Return (USD)"
  },
  {
    "key": "balance_total_usd",
    "type": "number",
    "title": "Total Balance (USD)"
  },
  {
    "key": "check_in_by_id",
    "type": "_id",
    "title": "Check-in By ID"
  },
  {
    "key": "check_in_at",
    "type": "date-time",
    "title": "Check-in At"
  },
  {
    "key": "check_in_by",
    "type": "string",
    "title": "Check-in By"
  },
  {
    "key": "check_in_note",
    "type": "string",
    "title": "Check-in Note"
  },
  {
    "key": "payment_by_id",
    "type": "_id",
    "title": "Payment By ID"
  },
  {
    "key": "payment_at",
    "type": "date-time",
    "title": "Payment At"
  },
  {
    "key": "payment_by",
    "type": "string",
    "title": "Payment By"
  },
  {
    "key": "payment_note",
    "type": "string",
    "title": "Payment Note"
  },
  {
    "key": "check_out_by_id",
    "type": "_id",
    "title": "Check-out By ID"
  },
  {
    "key": "check_out_at",
    "type": "date-time",
    "title": "Check-out At"
  },
  {
    "key": "check_out_by",
    "type": "string",
    "title": "Check-out By"
  },
  {
    "key": "check_out_note",
    "type": "string",
    "title": "Check-out Note"
  },
  {
    "key": "clean_by_id",
    "type": "_id",
    "title": "Clean By ID"
  },
  {
    "key": "clean_at",
    "type": "date-time",
    "title": "Clean At"
  },
  {
    "key": "clean_by",
    "type": "string",
    "title": "Clean By"
  },
  {
    "key": "clean_note",
    "type": "string",
    "title": "Clean Note"
  },
  {
    "key": "broke_by_id",
    "type": "_id",
    "title": "Broke By ID"
  },
  {
    "key": "broke_at",
    "type": "date-time",
    "title": "Broke At"
  },
  {
    "key": "broke_by",
    "type": "string",
    "title": "Broke By"
  },
  {
    "key": "broke_note",
    "type": "string",
    "title": "Broke Note"
  },
  {
    "key": "fix_by_id",
    "type": "_id",
    "title": "Fix By ID"
  },
  {
    "key": "fix_at",
    "type": "date-time",
    "title": "Fix At"
  },
  {
    "key": "fix_by",
    "type": "string",
    "title": "Fix By"
  },
  {
    "key": "fix_note",
    "type": "string",
    "title": "Fix Note"
  },
  {
    "key": "room_id",
    "type": "_id",
    "title": "Room ID"
  },
  {
    "key": "room_number",
    "type": "string",
    "title": "Room Number"
  },
  {
    "key": "room_type",
    "type": "string",
    "title": "Room Type"
  },
  {
    "key": "room_price_per_day_usd",
    "type": "number",
    "title": "Room Price/Day"
  },
  {
    "key": "room_price_per_3h_usd",
    "type": "number",
    "title": "Room Price/3H"
  },
  {
    "key": "room_status",
    "type": "string",
    "title": "Room Status"
  },
  {
    "key": "room_note",
    "type": "string",
    "title": "Room Note"
  },
  {
    "key": "front_desk_id",
    "type": "_id",
    "title": "Front Desk ID"
  },
  {
    "key": "guest_id",
    "type": "_id",
    "title": "Guest ID"
  },
  {
    "key": "guest_name",
    "type": "string",
    "title": "Guest Name"
  },
  {
    "key": "guest_phone",
    "type": "string",
    "title": "Guest Phone Number"
  },
  {
    "key": "guest_gender",
    "type": "string",
    "title": "Guest Gender"
  },
  {
    "key": "guest_nationality",
    "type": "string",
    "title": "Guest Nationality"
  },
  {
    "key": "guest_note",
    "type": "string",
    "title": "Guest Note"
  }
];

final ID = "_id";
final STAY_DURATION_DAY = "stay_duration_day";
final STAY_DURATION_HOUR = "stay_duration_hour";
final NUMBER_OF_GUESTS = "number_of_guests";
final SCHEDULE_CHECK_OUT = "schedule_check_out";
final ROOM_REVENUE_USD = "room_revenue_usd";
final PRICE_TOTAL_USD = "price_total_usd";
final PAID_BANK_USD = "paid_bank_usd";
final PAID_BANK_KHR = "paid_bank_khr";
final PAID_CASH_USD = "paid_cash_usd";
final PAID_CASH_KHR = "paid_cash_khr";
final PAID_TOTAL_USD = "paid_total_usd";
final RETURN_USD = "return_usd";
final RETURN_KHR = "return_khr";
final RETURN_TOTAL_USD = "return_total_usd";
final BALANCE_TOTAL_USD = "balance_total_usd";
final CHECK_IN_BY_ID = "check_in_by_id";
final CHECK_IN_AT = "check_in_at";
final CHECK_IN_BY = "check_in_by";
final CHECK_IN_NOTE = "check_in_note";
final PAYMENT_BY_ID = "payment_by_id";
final PAYMENT_AT = "payment_at";
final PAYMENT_BY = "payment_by";
final PAYMENT_NOTE = "payment_note";
final CHECK_OUT_BY_ID = "check_out_by_id";
final CHECK_OUT_AT = "check_out_at";
final CHECK_OUT_BY = "check_out_by";
final CHECK_OUT_NOTE = "check_out_note";
final CLEAN_BY_ID = "clean_by_id";
final CLEAN_AT = "clean_at";
final CLEAN_BY = "clean_by";
final CLEAN_NOTE = "clean_note";
final BROKE_BY_ID = "broke_by_id";
final BROKE_AT = "broke_at";
final BROKE_BY = "broke_by";
final BROKE_NOTE = "broke_note";
final FIX_BY_ID = "fix_by_id";
final FIX_AT = "fix_at";
final FIX_BY = "fix_by";
final FIX_NOTE = "fix_note";
final ROOM_ID = "room_id";
final ROOM_NUMBER = "room_number";
final ROOM_TYPE = "room_type";
final ROOM_PRICE_PER_DAY_USD = "room_price_per_day_usd";
final ROOM_PRICE_PER_3H_USD = "room_price_per_3h_usd";
final ROOM_STATUS = "room_status";
final ROOM_NOTE = "room_note";
final FRONT_DESK_ID = "front_desk_id";
final GUEST_ID = "guest_id";
final GUEST_NAME = "guest_name";
final GUEST_PHONE = "guest_phone";
final GUEST_GENDER = "guest_gender";
final GUEST_NATIONALITY = "guest_nationality";
final GUEST_NOTE = "guest_note";


void clear() {for (var s in data) s["value"] = null;}