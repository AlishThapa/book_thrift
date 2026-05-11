import "package:flutter/material.dart";
import "package:book_thrift/features/auth/auth_entry_page.dart";

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _index = 0;

  static const _pages = [
    _OnboardingData(
      icon: Icons.auto_stories_rounded,
      title: "Find Affordable\nUsed Books",
      subtitle: "Browse thousands of second-hand books at prices that won't break your budget.",
      color: Color(0xFF4F8EF7),
    ),
    _OnboardingData(
      icon: Icons.sell_rounded,
      title: "Sell Books You\nNo Longer Need",
      subtitle: "Turn your old textbooks and novels into cash with just a few taps.",
      color: Color(0xFF7C5CFC),
    ),
    _OnboardingData(
      icon: Icons.groups_rounded,
      title: "Connect With\nLocal Readers",
      subtitle: "Meet students and book lovers in your community and trade stories.",
      color: Color(0xFF2EBFA5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int v) {
    setState(() => _index = v);
    _animController.reset();
    _animController.forward();
  }

  void _navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthEntryPage()),
    );
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _navigate();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _pages[_index].color;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _navigate,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardingSlide(
                  data: _pages[i],
                  fadeAnim: i == _index ? _fadeAnim : const AlwaysStoppedAnimation(1),
                ),
              ),
            ),
            _BottomBar(
              index: _index,
              total: _pages.length,
              color: color,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data, required this.fadeAnim});

  final _OnboardingData data;
  final Animation<double> fadeAnim;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 72, color: data.color),
            ),
            const SizedBox(height: 40),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.index,
    required this.total,
    required this.color,
    required this.onNext,
  });

  final int index;
  final int total;
  final Color color;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = index == total - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(total, (i) {
              final active = i == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 6),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? color : (Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onNext,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLast ? 28 : 20,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLast ? "Get Started" : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}