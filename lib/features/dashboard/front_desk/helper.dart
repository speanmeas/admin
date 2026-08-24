// * ជំនួយផ្ទុកទិន្នន័យ front desk (បន្ទប់ + stay + ការទូទាត់)

import "package:speanmeas/core/utility/all.dart";

// * ផ្ទុកបន្ទប់ទាំងអស់ (តម្រូវតាមលេខបន្ទប់)
Future<List<Room>> load_rooms() async {
  final tmp = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
  if (tmp == null) return [];
  return [for (final d in (tmp.data ?? const [])) Room.fromJson(d)];
}

// * ផ្ទុកកំណត់ត្រា stay ទាំងអស់ (ថ្មីៗជាមុន)
Future<List<Front_Desk>> load_fds() async {
  final tmp = await dio.post(endpoint.FRONT_DESK_READ, data: {"key": Front_Desk.CHECK_IN_AT, "order": -1});
  if (tmp == null) return [];
  return [for (final d in (tmp.data ?? const [])) Front_Desk.fromJson(d)];
}

// * រក stay សកម្មរបស់បន្ទប់ (មិនទាន់ check out / cancel / delete)
Front_Desk? active_fd(List<Front_Desk> fds, String? room_id) {
  for (final fd in fds) {
    if (fd.room_id?.id != room_id) continue; // * មិនមែនបន្ទប់នេះ
    if (fd.check_out_at != null) continue; // * បាន check out
    if (fd.cancel_at != null) continue; // * បានបោះបង់
    if (fd.deleted_at != null) continue; // * បានលុប
    return fd;
  }
  return null;
}

// * តម្លៃនៃឯកសារទូទាត់ (price)
double price_of(dynamic pay) {
  if (pay is Pay_Room_Show) return pay.price ?? 0;
  if (pay is Mini_Bar_Pay_Show) return pay.price ?? 0;
  if (pay is Penalty_Pay_Show) return pay.price ?? 0;
  return 0;
}

// * ប្រាក់ដែលបានបង់ = cash + bank
double paid_of(dynamic pay) {
  if (pay is Pay_Room_Show) return (pay.cash ?? 0) + (pay.bank ?? 0);
  if (pay is Mini_Bar_Pay_Show) return (pay.cash ?? 0) + (pay.bank ?? 0);
  if (pay is Penalty_Pay_Show) return (pay.cash ?? 0) + (pay.bank ?? 0);
  return 0;
}

// * ប្រាក់នៅសល់ = price - paid
double due_of(dynamic pay) => price_of(pay) - paid_of(pay);

// * ប្រាក់ទូទាត់សរុបរបស់ stay (បន្ទប់ + mini bar + ពិន័យ)
double paid_total(Front_Desk? fd) => paid_of(fd?.room_pay_id) + paid_of(fd?.mini_bar_pay_id) + paid_of(fd?.penalty_pay_id);

// * តម្លៃសរុបរបស់ stay
double price_total(Front_Desk? fd) => price_of(fd?.room_pay_id) + price_of(fd?.mini_bar_pay_id) + price_of(fd?.penalty_pay_id);

// * ប្រាក់នៅសល់សរុបរបស់ stay
double due_total(Front_Desk? fd) => due_of(fd?.room_pay_id) + due_of(fd?.mini_bar_pay_id) + due_of(fd?.penalty_pay_id);
