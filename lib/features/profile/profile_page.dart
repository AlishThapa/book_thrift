import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/profile/widgets/profile_header.dart';
import 'package:book_thrift/features/profile/widgets/profile_stats.dart';
import 'package:book_thrift/features/profile/widgets/profile_menu_list.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final p = state.profile;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfile());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      profile: p,
                      onEdit: () async {
                        await context.pushRoute(EditProfileRoute(profile: p));
                        if (!context.mounted) return;
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: ProfileStats()),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.md),
                  ),
                  const ProfileMenuList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
