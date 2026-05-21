import 'package:flutter/material.dart';

class Setting_ extends StatefulWidget {
	const Setting_({super.key});

	@override
	State<Setting_> createState() => _Setting_State();
}

class _Setting_State extends State<Setting_> {
	final TextEditingController _propertyNameController = TextEditingController(text: 'SpeaknMeas Hotel');
	final TextEditingController _emailController = TextEditingController(text: 'admin@speaknmeas.com');
	final TextEditingController _phoneController = TextEditingController(text: '+855 12 345 678');

	String _timezone = 'Asia/Phnom_Penh';
	String _currency = 'USD';
	String _language = 'English';
	String _sessionTimeout = '30 minutes';

	bool _allowOverbooking = false;
	bool _autoCheckout = true;
	bool _emailAlerts = true;
	bool _smsAlerts = false;
	bool _require2fa = false;

	@override
	void dispose() {
		_propertyNameController.dispose();
		_emailController.dispose();
		_phoneController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final isMobile = MediaQuery.of(context).size.width < 900;

		return Scaffold(
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Manage Setting', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
						const SizedBox(height: 6),
						Text('Update property behavior, notifications and access controls.', style: Theme.of(context).textTheme.bodyMedium),
						const SizedBox(height: 16),

						Wrap(
							spacing: 16,
							runSpacing: 16,
							children: [
								SizedBox(width: isMobile ? double.infinity : 520, child: _buildPropertyProfileCard()),
								SizedBox(width: isMobile ? double.infinity : 520, child: _buildBookingCard()),
								SizedBox(width: isMobile ? double.infinity : 520, child: _buildNotificationCard()),
								SizedBox(width: isMobile ? double.infinity : 520, child: _buildSecurityCard()),
							],
						),

						const SizedBox(height: 20),
						Align(
							alignment: Alignment.centerRight,
							child: FilledButton.icon(
								onPressed: _save,
								icon: const Icon(Icons.save_outlined),
								label: const Text('Save Changes'),
							),
						),
					],
				),
			),
		);
	}

	Widget _buildPropertyProfileCard() {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Property Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
						const SizedBox(height: 12),
						TextField(
							controller: _propertyNameController,
							decoration: const InputDecoration(labelText: 'Property Name', isDense: true),
						),
						const SizedBox(height: 12),
						TextField(
							controller: _emailController,
							decoration: const InputDecoration(labelText: 'Contact Email', isDense: true),
						),
						const SizedBox(height: 12),
						TextField(
							controller: _phoneController,
							decoration: const InputDecoration(labelText: 'Contact Phone', isDense: true),
						),
						const SizedBox(height: 12),
						DropdownButtonFormField<String>(
							value: _timezone,
							decoration: const InputDecoration(labelText: 'Timezone', isDense: true),
							items: const [
								DropdownMenuItem(value: 'Asia/Phnom_Penh', child: Text('Asia/Phnom Penh')),
								DropdownMenuItem(value: 'Asia/Bangkok', child: Text('Asia/Bangkok')),
								DropdownMenuItem(value: 'UTC', child: Text('UTC')),
							],
							onChanged: (value) {
								if (value != null) {
									setState(() {
										_timezone = value;
									});
								}
							},
						),
					],
				),
			),
		);
	}

	Widget _buildBookingCard() {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Booking Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
						const SizedBox(height: 12),
						DropdownButtonFormField<String>(
							value: _currency,
							decoration: const InputDecoration(labelText: 'Currency', isDense: true),
							items: const [
								DropdownMenuItem(value: 'USD', child: Text('USD')),
								DropdownMenuItem(value: 'KHR', child: Text('KHR')),
								DropdownMenuItem(value: 'THB', child: Text('THB')),
							],
							onChanged: (value) {
								if (value != null) {
									setState(() {
										_currency = value;
									});
								}
							},
						),
						const SizedBox(height: 12),
						DropdownButtonFormField<String>(
							value: _language,
							decoration: const InputDecoration(labelText: 'Language', isDense: true),
							items: const [
								DropdownMenuItem(value: 'English', child: Text('English')),
								DropdownMenuItem(value: 'Khmer', child: Text('Khmer')),
							],
							onChanged: (value) {
								if (value != null) {
									setState(() {
										_language = value;
									});
								}
							},
						),
						const SizedBox(height: 12),
						SwitchListTile(
							value: _allowOverbooking,
							contentPadding: EdgeInsets.zero,
							title: const Text('Allow overbooking'),
							subtitle: const Text('Permit booking beyond available rooms.'),
							onChanged: (value) {
								setState(() {
									_allowOverbooking = value;
								});
							},
						),
						SwitchListTile(
							value: _autoCheckout,
							contentPadding: EdgeInsets.zero,
							title: const Text('Auto checkout after due time'),
							subtitle: const Text('Automatically close stays after checkout cutoff.'),
							onChanged: (value) {
								setState(() {
									_autoCheckout = value;
								});
							},
						),
					],
				),
			),
		);
	}

	Widget _buildNotificationCard() {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
						const SizedBox(height: 12),
						SwitchListTile(
							value: _emailAlerts,
							contentPadding: EdgeInsets.zero,
							title: const Text('Email alerts'),
							subtitle: const Text('Send booking and payment updates via email.'),
							onChanged: (value) {
								setState(() {
									_emailAlerts = value;
								});
							},
						),
						SwitchListTile(
							value: _smsAlerts,
							contentPadding: EdgeInsets.zero,
							title: const Text('SMS alerts'),
							subtitle: const Text('Send urgent updates to mobile numbers.'),
							onChanged: (value) {
								setState(() {
									_smsAlerts = value;
								});
							},
						),
					],
				),
			),
		);
	}

	Widget _buildSecurityCard() {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
						const SizedBox(height: 12),
						DropdownButtonFormField<String>(
							value: _sessionTimeout,
							decoration: const InputDecoration(labelText: 'Session timeout', isDense: true),
							items: const [
								DropdownMenuItem(value: '15 minutes', child: Text('15 minutes')),
								DropdownMenuItem(value: '30 minutes', child: Text('30 minutes')),
								DropdownMenuItem(value: '60 minutes', child: Text('60 minutes')),
							],
							onChanged: (value) {
								if (value != null) {
									setState(() {
										_sessionTimeout = value;
									});
								}
							},
						),
						const SizedBox(height: 12),
						SwitchListTile(
							value: _require2fa,
							contentPadding: EdgeInsets.zero,
							title: const Text('Require 2FA for admin users'),
							subtitle: const Text('Increase security for critical actions.'),
							onChanged: (value) {
								setState(() {
									_require2fa = value;
								});
							},
						),
					],
				),
			),
		);
	}

	void _save() {
		ScaffoldMessenger.of(context).showSnackBar(
			const SnackBar(content: Text('Settings saved successfully.')),
		);
	}
}
