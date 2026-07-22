Map<String, Map<String, dynamic>> data = {
  "_id": {"type": "_id", "title": "ID", "hide": true},
  "stay_day": {"type": "number", "title": "Stay (Days)", "hide": false},
  "stay_hour": {"type": "number", "title": "Stay (Hours)", "hide": false},
  "number_of_guests": {"type": "number", "title": "Number of Guests", "hide": false},
  "check_out_date": {"type": "date-time", "title": "Check-out Date", "hide": false},
  "room_price_total_usd": {"type": "number", "title": "Total Room Price (USD)", "hide": false},
  "room_paid_bank_usd": {"type": "number", "title": "Room Paid Bank (USD)", "hide": false},
  "room_paid_bank_khr": {"type": "number", "title": "Room Paid Bank (KHR)", "hide": false},
  "room_paid_cash_usd": {"type": "number", "title": "Room Paid Cash (USD)", "hide": false},
  "room_paid_cash_khr": {"type": "number", "title": "Room Paid Cash (KHR)", "hide": false},
  "room_paid_total_usd": {"type": "number", "title": "Total Room Paid (USD)", "hide": false},
  "room_return_usd": {"type": "number", "title": "Room Return (USD)", "hide": false},
  "room_return_khr": {"type": "number", "title": "Room Return (KHR)", "hide": false},
  "room_return_total_usd": {"type": "number", "title": "Total Room Return (USD)", "hide": false},
  "room_balance_total_usd": {"type": "number", "title": "Total Room Balance (USD)", "hide": false},
  "revenue_price_total_usd": {"type": "number", "title": "Total Revenue Price (USD)", "hide": false},
  "revenue_paid_bank_usd": {"type": "number", "title": "Revenue Paid Bank (USD)", "hide": false},
  "revenue_paid_bank_khr": {"type": "number", "title": "Revenue Paid Bank (KHR)", "hide": false},
  "revenue_paid_cash_usd": {"type": "number", "title": "Revenue Paid Cash (USD)", "hide": false},
  "revenue_paid_cash_khr": {"type": "number", "title": "Revenue Paid Cash (KHR)", "hide": false},
  "revenue_paid_total_usd": {"type": "number", "title": "Total Revenue Paid (USD)", "hide": false},
  "revenue_return_usd": {"type": "number", "title": "Revenue Return (USD)", "hide": false},
  "revenue_return_khr": {"type": "number", "title": "Revenue Return (KHR)", "hide": false},
  "revenue_return_total_usd": {"type": "number", "title": "Total Revenue Return (USD)", "hide": false},
  "revenue_balance_total_usd": {"type": "number", "title": "Total Revenue Balance (USD)", "hide": false},
  "note": {"type": "string", "title": "Note", "hide": false},
  "check_in_at": {"type": "date-time", "title": "Check-in At", "hide": false},
  "check_out_at": {"type": "date-time", "title": "Check-out At", "hide": false},
  "room_paid_at": {"type": "date-time", "title": "Room Payment At", "hide": false},
  "revenue_paid_at": {"type": "date-time", "title": "Revenue Payment At", "hide": false},
  "clean_at": {"type": "date-time", "title": "Clean At", "hide": false},
  "room_id": {"type": "_id", "title": "Room ID", "hide": true},
  "room_name": {"type": "string", "title": "Room Name", "hide": false},
  "room_note": {"type": "string", "title": "Room Note", "hide": false},
  "guest_id": {"type": "_id", "title": "Guest ID", "hide": true},
  "guest_full_name": {"type": "string", "title": "Guest Full Name", "hide": false},
  "guest_phone_number": {"type": "string", "title": "Guest Phone Number", "hide": false},
  "guest_gender": {"type": "string", "title": "Guest Gender", "hide": false},
  "guest_nationality": {"type": "string", "title": "Guest Nationality", "hide": false},
  "check_in_by": {"type": "string", "title": "Check-in By", "hide": false},
  "check_out_by": {"type": "string", "title": "Check-out By", "hide": false},
  "room_paid_by": {"type": "string", "title": "Room Payment By", "hide": false},
  "revenue_paid_by": {"type": "string", "title": "Revenue Payment By", "hide": false},
  "clean_by": {"type": "string", "title": "Clean By", "hide": false},
};

final ID = "_id";
final STAY_DAY = "stay_day";
final STAY_HOUR = "stay_hour";
final NUMBER_OF_GUESTS = "number_of_guests";
final CHECK_OUT_DATE = "check_out_date";
final ROOM_PRICE_TOTAL_USD = "room_price_total_usd";
final ROOM_PAID_BANK_USD = "room_paid_bank_usd";
final ROOM_PAID_BANK_KHR = "room_paid_bank_khr";
final ROOM_PAID_CASH_USD = "room_paid_cash_usd";
final ROOM_PAID_CASH_KHR = "room_paid_cash_khr";
final ROOM_PAID_TOTAL_USD = "room_paid_total_usd";
final ROOM_RETURN_USD = "room_return_usd";
final ROOM_RETURN_KHR = "room_return_khr";
final ROOM_RETURN_TOTAL_USD = "room_return_total_usd";
final ROOM_BALANCE_TOTAL_USD = "room_balance_total_usd";
final REVENUE_PRICE_TOTAL_USD = "revenue_price_total_usd";
final REVENUE_PAID_BANK_USD = "revenue_paid_bank_usd";
final REVENUE_PAID_BANK_KHR = "revenue_paid_bank_khr";
final REVENUE_PAID_CASH_USD = "revenue_paid_cash_usd";
final REVENUE_PAID_CASH_KHR = "revenue_paid_cash_khr";
final REVENUE_PAID_TOTAL_USD = "revenue_paid_total_usd";
final REVENUE_RETURN_USD = "revenue_return_usd";
final REVENUE_RETURN_KHR = "revenue_return_khr";
final REVENUE_RETURN_TOTAL_USD = "revenue_return_total_usd";
final REVENUE_BALANCE_TOTAL_USD = "revenue_balance_total_usd";
final NOTE = "note";
final CHECK_IN_AT = "check_in_at";
final CHECK_OUT_AT = "check_out_at";
final ROOM_PAID_AT = "room_paid_at";
final REVENUE_PAID_AT = "revenue_paid_at";
final CLEAN_AT = "clean_at";
final ROOM_ID = "room_id";
final ROOM_NAME = "room_name";
final ROOM_NOTE = "room_note";
final GUEST_ID = "guest_id";
final GUEST_FULL_NAME = "guest_full_name";
final GUEST_PHONE_NUMBER = "guest_phone_number";
final GUEST_GENDER = "guest_gender";
final GUEST_NATIONALITY = "guest_nationality";
final CHECK_IN_BY = "check_in_by";
final CHECK_OUT_BY = "check_out_by";
final ROOM_PAID_BY = "room_paid_by";
final REVENUE_PAID_BY = "revenue_paid_by";
final CLEAN_BY = "clean_by";
