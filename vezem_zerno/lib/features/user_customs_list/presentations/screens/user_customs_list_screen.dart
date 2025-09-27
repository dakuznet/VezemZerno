import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';

@RoutePage()
class UserCustomsListScreen extends StatefulWidget {
  const UserCustomsListScreen({super.key});

  @override
  State<UserCustomsListScreen> createState() => _UserCustomsListScreenState();
}

class _UserCustomsListScreenState extends State<UserCustomsListScreen> {
  static const _activeTabIndex = 0;
  static const _historyTabIndex = 1;
  static const _appBarExpandedHeight = 150.0;

  int _selectedTab = _activeTabIndex;
  bool _isEmptyState = true;

  void _handleTabSelection(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                _buildContent(),
                // Add spacing for the fixed button
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
          ),
          _buildFixedButton(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text(''), // Empty title for flexible space customization
      expandedHeight: _appBarExpandedHeight.h,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: ColorsConstants.primaryBrownColor,
              size: 24.sp,
            ),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ),
      ],
      flexibleSpace: _buildFlexibleSpace(context),
    );
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final currentHeight = constraints.maxHeight;
        final collapseFactor = 1 - (currentHeight / _appBarExpandedHeight.h);
        final topPadding = MediaQuery.of(context).padding.top;

        return Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15.r),
                ),
              ),
            ),

            // Centered title at the top
            Positioned(
              top: topPadding + 10.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Мои заявки',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
            ),

            // Tab buttons (disappear on scroll)
            Positioned(
              bottom: 20.h,
              left: 0.w,
              right: 0.w,
              child: Opacity(
                opacity: 1 - collapseFactor.clamp(0.0, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton(
                      text: 'Активные',
                      isSelected: _selectedTab == _activeTabIndex,
                      onTap: () => _handleTabSelection(_activeTabIndex),
                    ),
                    SizedBox(width: 32.w),
                    _buildTabButton(
                      text: 'История',
                      isSelected: _selectedTab == _historyTabIndex,
                      onTap: () => _handleTabSelection(_historyTabIndex),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? ColorsConstants.primaryBrownColor
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: isSelected
                ? ColorsConstants.primaryBrownColor
                : ColorsConstants.primaryBrownColorWithOpacity,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
      child: _isEmptyState
          ? _buildEmptyState()
          : _buildCustomsList(), // TODO: Implement list builder when data is available
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: ColorsConstants.primaryTextFormFieldBackgorundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _selectedTab == _activeTabIndex
                  ? Icons.list_alt_outlined
                  : Icons.history_outlined,
              size: 40.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            _selectedTab == _activeTabIndex
                ? 'У вас нет ни одной активной заявки'
                : 'История заявок пуста',
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomsList() {
    // TODO: Implement actual list builder when data is available
    return const SizedBox.shrink();
  }

  Widget _buildFixedButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsConstants.backgroundColor,
        border: Border(
          top: BorderSide(
            color: ColorsConstants.primaryBrownColorWithOpacity,
            width: 1.0.w,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(text: 'Создать заявку', onPressed: () {}),
      ),
    );
  }
}
