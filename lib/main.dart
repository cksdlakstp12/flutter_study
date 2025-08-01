import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Button.dart';
import 'package:flutter_application_1/widgets/currency_card.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181818),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181818),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF1B33B), // 버튼 강조색
          surface: Color(0xFF1F2123), // 카드/블록 배경
          onSurface: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/about': (_) => const AboutPage(),
        '/product': (_) => const ProductPage(),
        '/funding': (_) => const FundingPage(),
        '/support': (_) => const SupportPage(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}

/// -----------------------------
/// Top Navigation Bar
/// -----------------------------
class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;
  final void Function(String sectionId)? onSubSection; // 스크롤 콜백

  const TopNavBar({super.key, required this.currentRoute, this.onSubSection});

  static void _goTo(BuildContext context, String route, {String? sectionId}) {
    if (ModalRoute.of(context)?.settings.name == route && sectionId == null) {
      return; // 이미 현재 페이지
    }
    Navigator.of(context).pushNamed(route, arguments: sectionId);
  }

  Widget _navItem(
    BuildContext context, {
    required String label,
    required String route,
    Map<String, String> subSections = const {}, // id -> label
  }) {
    final bool isActive = currentRoute == route;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withOpacity(isActive ? 1 : 0.85),
          ),
          onPressed: () {
            if (currentRoute == route) {
              onSubSection?.call('__top__'); // 같은 페이지면 맨 위로
            } else {
              _goTo(context, route);
            }
          },
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        if (subSections.isNotEmpty)
          PopupMenuButton<String>(
            color: const Color(0xFF2A2A2A),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            onSelected: (sectionId) {
              if (currentRoute == route) {
                onSubSection?.call(sectionId);
              } else {
                _goTo(context, route, sectionId: sectionId);
              }
            },
            itemBuilder:
                (ctx) =>
                    subSections.entries
                        .map(
                          (e) => PopupMenuItem<String>(
                            value: e.key,
                            child: Text(
                              e.value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: '메인으로',
        icon: const Icon(Icons.home, color: Colors.white),
        onPressed: () {
          if (currentRoute == '/') {
            onSubSection?.call('__top__');
          } else {
            Navigator.of(context).pushNamed('/');
          }
        },
      ),
      title: const Text(''),
      centerTitle: false,
      actions: [
        _navItem(
          context,
          label: '회사 소개',
          route: '/about',
          subSections: const {'vision': '회사의 비전', 'people': '사람들'},
        ),
        _navItem(
          context,
          label: '제품 소개',
          route: '/product',
          subSections: const {'purchase': '구매'},
        ),
        _navItem(
          context,
          label: '펀딩',
          route: '/funding',
          subSections: const {'go_funding': '펀딩 사이트로 이동'},
        ),
        _navItem(
          context,
          label: '고객지원',
          route: '/support',
          subSections: const {'board': '게시판'},
        ),
        _navItem(
          context,
          label: '로그인',
          route: '/login',
          subSections: const {'mypage': '마이페이지', 'signup': '회원가입'},
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// -----------------------------
/// 공통 섹션 위젯 & 스크롤 믹스인
/// -----------------------------
class Section extends StatelessWidget {
  final GlobalKey keyRef;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const Section({
    super.key,
    required this.keyRef,
    required this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyRef,
      padding: padding,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: const Color(0xFF1F2123), // 다크 카드 배경
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            subtitle!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (child != null) const SizedBox(height: 14),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

mixin SectionScrolling<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> sectionKeys = {}; // sectionId -> GlobalKey

  void registerSection(String id, GlobalKey key) {
    sectionKeys[id] = key;
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  void scrollToSection(String sectionId) {
    if (sectionId == '__top__') {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
      return;
    }
    final key = sectionKeys[sectionId];
    if (key != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToKey(key));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToSection(args),
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

/// -----------------------------
/// 페이지들
/// -----------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SectionScrolling {
  final GlobalKey _topKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('hero', _topKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(currentRoute: '/', onSubSection: scrollToSection),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          key: _topKey,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text(
                "Welcome to Our Company",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 120),
              Text(
                "Total Balance",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "\$5 194 482",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Button(
                    text: "Transfer",
                    bgColor: Color(0xFFF1B33B),
                    textColor: Colors.black,
                  ),
                  Button(
                    text: "Request",
                    bgColor: Color(0xFF1F2123),
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Wallets",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const CurrencyCard(
                name: "Euro",
                code: "EUR",
                amount: "6 428",
                icon: Icons.euro_rounded,
                isInverted: false,
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: const CurrencyCard(
                  name: "Bitcoin",
                  code: "BTC",
                  amount: "9 785",
                  icon: Icons.currency_bitcoin,
                  isInverted: true,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CurrencyCard(
                  name: "Dollar",
                  code: "USD",
                  amount: "428",
                  icon: Icons.attach_money_outlined,
                  isInverted: false,
                ),
              ),
              const SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SectionScrolling {
  final GlobalKey _visionKey = GlobalKey();
  final GlobalKey _peopleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('vision', _visionKey);
    registerSection('people', _peopleKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(currentRoute: '/about', onSubSection: scrollToSection),
      body: ListView(
        controller: scrollController,
        children: [
          Section(
            keyRef: _visionKey,
            title: '회사 소개',
            subtitle: '회사 전반을 소개하는 영역입니다.',
            child: const Text('비전, 미션, 연혁, 수상 경력 등 핵심 정보를 요약해 주세요.'),
          ),
          Section(
            keyRef: _peopleKey,
            title: '사람들',
            subtitle: '팀원, 리더십, 채용 정보 등',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                6,
                (i) => Chip(
                  label: Text('팀원 ${i + 1}'),
                  backgroundColor: const Color(0xFF2A2A2A),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SectionScrolling {
  final GlobalKey _purchaseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('purchase', _purchaseKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        currentRoute: '/product',
        onSubSection: scrollToSection,
      ),
      body: ListView(
        controller: scrollController,
        children: [
          Section(
            keyRef: GlobalKey(),
            title: '제품 소개',
            subtitle: '제품 특징, 데모, 가격 등을 소개합니다.',
            child: const Text('제품 스크린샷, 스펙, 장점, 사용 예시 등을 넣어보세요.'),
          ),
          Section(
            keyRef: _purchaseKey,
            title: '구매',
            subtitle: '구매 플로우/가격표/결제 연결',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('가격표 예시'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: const [
                    Chip(
                      label: Text('Basic'),
                      backgroundColor: Color(0xFF2A2A2A),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    Chip(
                      label: Text('Pro'),
                      backgroundColor: Color(0xFF2A2A2A),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    Chip(
                      label: Text('Enterprise'),
                      backgroundColor: Color(0xFF2A2A2A),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF1B33B),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text('지금 구매'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}

class FundingPage extends StatefulWidget {
  const FundingPage({super.key});

  @override
  State<FundingPage> createState() => _FundingPageState();
}

class _FundingPageState extends State<FundingPage> with SectionScrolling {
  final GlobalKey _goFundingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('go_funding', _goFundingKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        currentRoute: '/funding',
        onSubSection: scrollToSection,
      ),
      body: ListView(
        controller: scrollController,
        children: [
          Section(
            keyRef: GlobalKey(),
            title: '펀딩',
            subtitle: '프로젝트 개요/타임라인/리워드 소개',
            child: const Text('프로젝트의 배경과 목표, 진행 상황, 리워드 구성 등을 소개하세요.'),
          ),
          Section(
            keyRef: _goFundingKey,
            title: '펀딩 사이트로 이동',
            subtitle: '아래 버튼을 누르면 외부 펀딩 페이지로 이동합니다.',
            trailing: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF1B33B),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // TODO: url_launcher 사용해 실제 URL로 이동하세요.
                // launchUrl(Uri.parse('https://your-funding-site.example'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('URL 이동은 url_launcher 설정 후 연결해 주세요.'),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('이동하기'),
            ),
            child: const Text(
              'pubspec.yaml에 url_launcher를 추가하면 실제로 이동할 수 있어요.',
            ),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> with SectionScrolling {
  final GlobalKey _boardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('board', _boardKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        currentRoute: '/support',
        onSubSection: scrollToSection,
      ),
      body: ListView(
        controller: scrollController,
        children: [
          Section(
            keyRef: GlobalKey(),
            title: '고객지원',
            subtitle: 'FAQ / 문의 / 공지',
            child: const Text('자주 묻는 질문, 공지사항, 1:1 문의 등을 제공하세요.'),
          ),
          Section(
            keyRef: _boardKey,
            title: '게시판',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: const Color(0xFF2A2A2A),
                  leading: const Icon(
                    Icons.article_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    '[공지] 서비스 업데이트 노트',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '2025-08-01',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 1, color: Colors.white24),
                ListTile(
                  tileColor: const Color(0xFF2A2A2A),
                  leading: const Icon(
                    Icons.question_answer_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    '결제 관련 질문 드립니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '사용자 A · 3시간 전',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SectionScrolling {
  final GlobalKey _mypageKey = GlobalKey();
  final GlobalKey _signupKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    registerSection('mypage', _mypageKey);
    registerSection('signup', _signupKey);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
    );

    return Scaffold(
      appBar: TopNavBar(currentRoute: '/login', onSubSection: scrollToSection),
      body: ListView(
        controller: scrollController,
        children: [
          Section(
            keyRef: GlobalKey(),
            title: '로그인',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '이메일',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Color(0xFFF1B33B)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Color(0xFFF1B33B)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF1B33B),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text('로그인'),
                ),
              ],
            ),
          ),
          Section(
            keyRef: _mypageKey,
            title: '마이페이지',
            subtitle: '사용자 정보, 주문 내역, 설정',
            child: Wrap(
              spacing: 12,
              children: const [
                Chip(
                  label: Text('프로필'),
                  backgroundColor: Color(0xFF2A2A2A),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                Chip(
                  label: Text('주문 내역'),
                  backgroundColor: Color(0xFF2A2A2A),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                Chip(
                  label: Text('설정'),
                  backgroundColor: Color(0xFF2A2A2A),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Section(
            keyRef: _signupKey,
            title: '회원가입',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('간단한 회원가입 폼 예시'),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '이메일',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Color(0xFFF1B33B)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Color(0xFFF1B33B)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Color(0xFFF1B33B)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF1B33B),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text('가입하기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}
