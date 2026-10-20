import 'package:flutter/material.dart';

/// A telebirr service: either a partner mark ([logo]) or a line [icon].
class Service {
  const Service(this.label, {this.logo, this.icon, this.badge});

  final String label;
  final String? logo;
  final IconData? icon;
  final String? badge;
}

const _b = 'assets/brand';

// ── Home ────────────────────────────────────────────────────────────────
const sendMoney = Service('Send Money', icon: Icons.outbox_rounded);
const cashInOut = Service(
  'Cash In / Out',
  icon: Icons.account_balance_wallet_outlined,
);
const airtime = Service(
  'Airtime / Package',
  icon: Icons.celebration_outlined,
  badge: 'Up to 35%',
);
const zemen = Service('Zemen Gebeya', logo: '$_b/zemen.png');

const homeServices = <Service>[
  Service('Dashen Bank', logo: '$_b/dashen.png'),
  Service('CBE', logo: '$_b/cbe.png'),
  Service('Siinqee Bank', logo: '$_b/siinqee.png'),
  Service('Transfer to Bank', icon: Icons.account_balance_outlined),
  Service('Awash Bank', logo: '$_b/awash.png'),
  Service('Pay Merchant', icon: Icons.storefront_outlined),
  Service('teleEV Charging', logo: '$_b/teleev.png'),
  Service('TOLO Payment', logo: '$_b/tolo.png'),
  Service('AA Traffic Penalty', logo: '$_b/aa_traffic.png'),
  Service('AATMA Parking', logo: '$_b/aa_traffic.png'),
  Service('tele Device Financing', logo: '$_b/device_fin.png'),
];

// ── Payment ─────────────────────────────────────────────────────────────
class PaymentCategory {
  const PaymentCategory(this.title, this.icon, this.items);

  final String title;
  final IconData icon;
  final List<Service> items;
}

const paymentCategories = <PaymentCategory>[
  PaymentCategory('Utility', Icons.bolt_rounded, [
    Service('Pay Ethio telecom Bill', logo: '$_b/ethiotelecom_mark.png'),
    Service('Electric Utility', logo: '$_b/electric.png'),
    Service('Addis Ababa Water', logo: '$_b/aawsa.png'),
    Service('Water by Derash', logo: '$_b/derash.png'),
    Service('Water by WeBirr', logo: '$_b/webirr.png'),
    Service('W M General Trading', icon: Icons.recycling_rounded),
    Service('Water by UniCash', logo: '$_b/unicash.png'),
    Service('Ethiopian Electric Utility', logo: '$_b/electric.png'),
    Service('WebSprix', logo: '$_b/websprix.png'),
    Service('Water by Palaba', logo: '$_b/palaba.png'),
  ]),
  PaymentCategory('Tax & Government', Icons.account_balance_rounded, [
    Service('E-Services', logo: '$_b/eservices.png'),
    Service('AA Traffic Penalty', logo: '$_b/aa_traffic.png'),
    Service('NID (Fayda)', logo: '$_b/fayda.png'),
  ]),
  PaymentCategory('MESOB One-stop', Icons.apartment_rounded, [
    Service('MESOB Services', icon: Icons.apartment_rounded),
    Service('NID Printing', logo: '$_b/fayda.png'),
  ]),
  PaymentCategory('Transport', Icons.directions_bus_rounded, [
    Service('Ethiopian Airlines', logo: '$_b/ethiopian.png'),
    Service('RIDE', logo: '$_b/ride.png'),
    Service('Public Transport', logo: '$_b/publictransport.png'),
    Service('TOLO Payment', logo: '$_b/tolo.png'),
    Service('AATMA Parking', logo: '$_b/aa_traffic.png'),
  ]),
  PaymentCategory('Entertainment', Icons.movie_outlined, [
    Service('MyDStv', logo: '$_b/mydstv.png'),
    Service('Great Ethiopian Run', logo: '$_b/ger.png'),
  ]),
  PaymentCategory('E-commerce', Icons.shopping_bag_outlined, [
    Service('Zemen Gebeya', logo: '$_b/zemen.png'),
    Service('Hulu beje', logo: '$_b/hulubeje.png'),
    Service('HOWLOW', logo: '$_b/howlow.png'),
  ]),
  PaymentCategory('Event & Ticketing', Icons.confirmation_number_outlined, [
    Service('Great Ethiopian Run', logo: '$_b/ger.png'),
  ]),
];

// ── Apps ────────────────────────────────────────────────────────────────
/// Engage moved from the tab bar into Apps.
const engageApp = Service('Engage', logo: '$_b/engage.png');

const miniApps = <Service>[
  engageApp,
  Service('My Ethiotel', logo: '$_b/ethiotelecom_mark.png'),
  Service('telebirrRemit', icon: Icons.public_rounded),
  Service('tele-Online Fixed', icon: Icons.router_outlined),
  Service('Ethiopian Airlines', logo: '$_b/ethiopian.png'),
  Service('NID (Fayda) Digital ID', logo: '$_b/fayda.png'),
  Service('Ethiopian Shipping', logo: '$_b/esl.png'),
  Service('Teninete', logo: '$_b/teninete.png'),
  Service('NID (Fayda) printing', logo: '$_b/fayda.png'),
  Service('MyDStv', logo: '$_b/mydstv.png'),
  Service('HOWLOW', logo: '$_b/howlow.png'),
  Service('SITOTA', icon: Icons.card_giftcard_rounded),
  Service('E-Services', logo: '$_b/eservices.png'),
  Service('Great Ethiopian Run', logo: '$_b/ger.png'),
  Service('Medhin Link', logo: '$_b/medhin.png'),
  Service('RIDE', logo: '$_b/ride.png'),
  Service('Public Transport', logo: '$_b/publictransport.png'),
  Service('Hulu beje', logo: '$_b/hulubeje.png'),
  Service('WebSprix', logo: '$_b/websprix.png'),
];

// ── Account ─────────────────────────────────────────────────────────────
class AccountItem {
  const AccountItem(this.label, this.icon, {this.trailing, this.logo});

  final String label;
  final IconData icon;
  final String? trailing;
  final String? logo;
}

const accountGroups = <String, List<AccountItem>>{
  'SECURITY': [
    AccountItem(
      'Verify / Upgrade with Fayda',
      Icons.verified_user_outlined,
      logo: '$_b/fayda.png',
    ),
    AccountItem('Change PIN', Icons.lock_outline_rounded),
    AccountItem('Security Question', Icons.quiz_outlined),
    AccountItem('Biometric Authentication', Icons.fingerprint_rounded),
  ],
  'PREFERENCES': [
    AccountItem(
      'Change Language',
      Icons.translate_rounded,
      trailing: 'English',
    ),
    AccountItem('My Coupon', Icons.local_activity_outlined),
    AccountItem('Bill Share History', Icons.receipt_long_outlined),
    AccountItem('Verify Payment', Icons.task_alt_rounded),
  ],
  'SUPPORT': [
    AccountItem('FAQ', Icons.help_outline_rounded),
    AccountItem('Feedback', Icons.rate_review_outlined),
    AccountItem('Contact Us', Icons.support_agent_rounded),
    AccountItem('Share', Icons.ios_share_rounded),
    AccountItem('About', Icons.info_outline_rounded),
  ],
};

// ── Recent contacts (made-up example data) ──────────────────────────────
class Contact {
  const Contact(this.name, this.phone, this.tint, {this.lastSent = ''});

  final String name;
  final String phone;
  final Color tint;

  /// When you last sent to this person, e.g. "Nov 12".
  final String lastSent;

  String get firstName => name.split(' ').first;

  String get initials => name
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0])
      .join()
      .toUpperCase();
}

const recentContacts = <Contact>[
  Contact(
    'Abebe Kebede',
    '+251 91 120 4471',
    Color(0xFFCDEBD3),
    lastSent: 'Oct 18',
  ),
  Contact(
    'Hanna Tesfaye',
    '+251 92 845 1203',
    Color(0xFFFFDBC5),
    lastSent: 'Oct 12',
  ),
  Contact(
    'Selam Girma',
    '+251 94 330 9182',
    Color(0xFFCDE8F5),
    lastSent: 'Oct 3',
  ),
  Contact(
    'Dawit Alemu',
    '+251 91 667 0215',
    Color(0xFFE6D9F5),
    lastSent: 'Sep 27',
  ),
  Contact(
    'Meron Haile',
    '+251 93 512 7740',
    Color(0xFFFDE99B),
    lastSent: 'Sep 20',
  ),
];

/// A recent transaction for the activity strip (made-up example data).
class Txn {
  const Txn(this.title, this.subtitle, this.amount, this.icon);

  final String title;
  final String subtitle;
  final double amount;
  final IconData icon;
}

const recentTxns = <Txn>[
  Txn('Airtime top-up', 'Today · 09:12', -25.00, Icons.celebration_outlined),
  Txn(
    'From Abebe Kebede',
    'Yesterday · 18:40',
    150.00,
    Icons.south_west_rounded,
  ),
  Txn('Electric Utility', 'Mon · 11:05', -312.40, Icons.bolt_rounded),
];
