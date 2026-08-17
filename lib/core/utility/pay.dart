// * ឧបករណ៍ការពារការសងលើស (over-refund guard)
// * កាត់តម្លៃកុំឱ្យ net ក្រោម 0
// * net_price = Σ(add_price) - Σ(sub_price) ; net_paid = Σ(add_cash + add_bank) - Σ(sub_return)

// * កាត់ sub_price ដើម្បីកុំឱ្យ net_price ក្រោម 0 (ករណីកាត់បន្ថយតម្លៃ/រយៈពេលស្នាក់នៅ)
double clamp_sub_price(double sub_price, double old_price, double add_price) {
  if (sub_price <= 0) return 0;
  final max_sub = old_price + add_price;
  if (max_sub <= 0) return 0;
  return sub_price > max_sub ? max_sub : sub_price;
}

// * កាត់ sub_return ដើម្បីកុំឱ្យ net_paid ក្រោម 0 (ករណីសងប្រាក់វិញ)
double clamp_sub_return(double sub_return, double last_paid, double add_cash, double add_bank) {
  if (sub_return <= 0) return 0;
  final max_return = last_paid + add_cash + add_bank;
  if (max_return <= 0) return 0;
  return sub_return > max_return ? max_return : sub_return;
}
