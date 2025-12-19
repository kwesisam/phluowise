import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/controllers/theme_controller.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/models/branch_model.dart';
import 'package:phluowise/screens/sub/branch_details.dart';
import 'package:phluowise/screens/sub/profile.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAround = true;
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    final appWrite = context.watch<AppwriteAuthProvider>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(
            appWrite.userData != null
                ? 'Good Morning ${appWrite.userData!.fullName}'
                : 'Good Morning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          actionsPadding: EdgeInsets.only(left: 40),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                width: 45,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: themeController.isDarkMode
                      ? HexColor('#4D40444B')
                      : HexColor('#40444B'),
                  border: Border.all(
                    color: themeController.isDarkMode
                        ? HexColor('#808080')
                        : HexColor('#40444B'),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    pushScreen(context, screen: Profile());
                  },
                  icon: SvgPicture.asset(AppImages.menu),
                ),
              ),
            ),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: context.screenWidth * .95,
                child: search(),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: context.screenWidth * .95,
                child: filter(),
              ),
            ),
            SizedBox(height: 15),
            Expanded(child: content(isGrid: isGrid)),
          ],
        ),
      ),
    );
  }

  Widget search() {
    return TextField(
      decoration: InputDecoration(
        fillColor: HexColor('#40444B'),
        filled: true,
        hintText: 'Search',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: HexColor('#40444B')),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: HexColor('#40444B')),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 5),
          child: SvgPicture.asset(AppImages.search, width: 23, height: 23),
        ),
        suffixIconConstraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
      ),
    );
  }

  Widget filter() {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: Button(
            buttonText: 'Around you',
            borderRadius: 8,
            type: isAround == true ? 'primary' : 'transparent',
            fontSize: 15,
            onPressed: () {
              if (isAround == false) {
                setState(() {
                  isAround = true;
                });
              }
            },
          ),
        ),
        Spacer(),
        Button(
          buttonText: 'All',
          type: isAround == false ? 'primary' : 'transparent',
          borderRadius: 8,
          fontSize: 15,
          onPressed: () {
            if (isAround == true) {
              setState(() {
                isAround = false;
              });
            }
          },
        ),
        InkWell(
          onTap: () {
            setState(() {
              isGrid = !isGrid;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 9),
            decoration: BoxDecoration(
              color: HexColor('#292B2F'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(AppImages.tablerSwipe),
          ),
        ),
      ],
    );
  }

  Widget content({required bool isGrid}) {
    return Consumer<AppwriteAuthProvider>(
      builder: (context, provider, child) {
        final branches = provider.branches;

        if (branches.isEmpty) {
          return const Center(child: Text('No branches available'));
        }

        return isGrid ? _buildGrid(context, branches) : _buildList(branches);
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<Map<String, dynamic>> branches) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.95,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: branches.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.83,
          ),
          itemBuilder: (context, index) {
            final branch = Branch.fromJson(branches[index]);
            return gridCard(branch: branch);
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> branches) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = Branch.fromJson(branches[index]);
        return columnCard(branch: branch);
      },
    );
  }

  Widget gridCard({required Branch branch}) {
    final bool isDark = ThemeController().isDarkMode;

    return InkWell(
      onTap: () {
        pushScreenWithoutNavBar(context, BranchDetails(branch:  branch,));
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? HexColor('#4D515357') : HexColor('#40444B'),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4.2),
              blurRadius: 20.98,
              spreadRadius: 0,
              color: HexColor('#26000000'),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Header Image (from Appwrite)
            if (branch.headerImage != null && branch.headerImage!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: branch.headerImage!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[400],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              )
            else
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.image2),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Profile Logo
            Positioned(
              top: 130,
              left: 10,
              child: Container(
                width: 58,
                height: 53,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: HexColor('#40444B')),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      branch.profileImage != null &&
                          branch.profileImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: branch.profileImage!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: Colors.grey[300]),
                          errorWidget: (_, __, ___) =>
                              Image.asset(AppImages.image1, fit: BoxFit.cover),
                        )
                      : Image.asset(AppImages.image1, fit: BoxFit.cover),
                ),
              ),
            ),

            // Branch Name
            Positioned(
              top: 190,
              left: 10,
              child: Text(
                branch.branchName ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnCard({required Branch branch}) {
    final bool isDark = ThemeController().isDarkMode;

    return InkWell(
      onTap: () {
        pushScreenWithoutNavBar(context, BranchDetails(branch:  branch,));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? HexColor('#CC101010') : HexColor('#40444B'),
          border: Border(
            bottom: BorderSide(
              width: 1.5,
              color: isDark ? HexColor('#DADADA') : HexColor('#1D1D1D'),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Branch Profile Image
            Container(
              width: 89,
              height: 89,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(11),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child:
                    branch.headerImage != null && branch.headerImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: branch.headerImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.business, color: Colors.white54),
                      )
                    : const Icon(Icons.business, color: Colors.white54),
              ),
            ),

            const SizedBox(width: 13),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.branchName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    branch.location ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '23 minutes away',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // View Shop
            Column(
              children: [
                SvgPicture.asset(AppImages.shop),
                const SizedBox(height: 4),
                const Text(
                  'View shop',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
