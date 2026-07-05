List<Map<String, dynamic>> schema = [
  // room info
  {"key": "room_number", "type": "string", "title": "Room Number"},
  {"key": "room_type", "type": "string", "title": "Room Type"},
  {"key": "room_price_per_day_usd", "type": "number", "title": "Room Price/Day"},
  {"key": "room_price_per_3h_usd", "type": "number", "title": "Room Price/3H"},
  // {"key": "room_status", "type": "string", "title": "Room Status"},
  // {"key": "room_note", "type": "string", "title": "Room Note"},

  // guest info
  {"key": "guest_name", "type": "string", "title": "Guest Name"},
  {"key": "guest_gender", "type": "string", "title": "Guest Gender"},
  {"key": "guest_phone", "type": "string", "title": "Guest Phone Number"},
  {"key": "guest_nationality", "type": "string", "title": "Guest Nationality"},
  // {"key": "guest_note", "type": "string", "title": "Guest Note"},

  // stay info
  {"key": "stay_duration_day", "type": "number", "title": "Stay (Days)"},
  {"key": "stay_duration_hour", "type": "number", "title": "Stay (Hours)"},
  {"key": "number_of_guests", "type": "number", "title": "Number of Guests"},
  {"key": "schedule_check_out", "type": "date-time", "title": "Schedule Check-out"},

  // payment info
  {"key": "price_total_usd", "type": "number", "title": "Total Price (USD)"},
  {"key": "paid_bank_usd", "type": "number", "title": "Paid Bank (USD)"},
  {"key": "paid_bank_khr", "type": "number", "title": "Paid Bank (KHR)"},
  {"key": "paid_cash_usd", "type": "number", "title": "Paid Cash (USD)"},
  {"key": "paid_cash_khr", "type": "number", "title": "Paid Cash (KHR)"},
  {"key": "paid_total_usd", "type": "number", "title": "Total Paid (USD)"},
  {"key": "return_usd", "type": "number", "title": "Return (USD)"},
  {"key": "return_khr", "type": "number", "title": "Return (KHR)"},
  {"key": "return_total_usd", "type": "number", "title": "Total Return (USD)"},
  {"key": "balance_total_usd", "type": "number", "title": "Total Balance (USD)"},

  // timestamp
  {"key": "check_in_at", "type": "date-time", "title": "Check-in At"},
  {"key": "check_in_by", "type": "string", "title": "Check-in By"},
  {"key": "check_in_note", "type": "string", "title": "Check-in Note"},
  {"key": "payment_at", "type": "date-time", "title": "Payment At"},
  {"key": "payment_by", "type": "string", "title": "Payment By"},
  {"key": "payment_note", "type": "string", "title": "Payment Note"},
  {"key": "check_out_at", "type": "date-time", "title": "Check-out At"},
  {"key": "check_out_by", "type": "string", "title": "Check-out By"},
  {"key": "check_out_note", "type": "string", "title": "Check-out Note"},
  {"key": "clean_at", "type": "date-time", "title": "Clean At"},
  {"key": "clean_by", "type": "string", "title": "Clean By"},
  {"key": "clean_note", "type": "string", "title": "Clean Note"},

  // id
  {"key": "guest_id", "type": "_id", "title": "Guest"},
  {"key": "_id", "type": "_id", "title": "ID"},
  {"key": "room_id", "type": "_id", "title": "Room"},
];
