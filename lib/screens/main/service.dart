import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/controllers/theme_controller.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/models/branch_model.dart';
import 'package:phluowise/models/product_model.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:provider/provider.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  int _current = 0;
  int _totalPages = 2;
  final CarouselSliderController _controller = CarouselSliderController();

  bool isCarousel = false;

  void _goBack() {
    if (_current > 0) {
      setState(() {
        _current--;
      });
      _controller.animateToPage(_current);
    }
  }

  void _goForward() {
    if (_current < _totalPages - 1) {
      setState(() {
        _current++;
      });
      _controller.animateToPage(_current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    final appWrite = context.watch<AppwriteAuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: context.screenWidth * .95,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Expanded(child: search()),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCarousel = !isCarousel;
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 42,
                        height: 42,

                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HexColor('#292B2F'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          AppImages.document,
                          color: isCarousel
                              ? HexColor('#3B74FF')
                              : HexColor('#E6E6E6'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Center(
            //   child: SizedBox(
            //     width: context.screenWidth * .95,
            //     child: filter(),
            //   ),
            // ),
            // SizedBox(height: 15),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: context.screenWidth * .85,
                  child: content(isCarousel: isCarousel),
                ),
              ),
            ),

            SizedBox(height: 20),
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

  Widget content({required bool isCarousel}) {
    return Consumer<AppwriteAuthProvider>(
      builder: (context, provider, child) {
        final branches = provider.branches;

        if (branches.isEmpty) {
          return const Center(child: Text('No branches available'));
        }

        _totalPages = branches.length;

        return isCarousel
            ? _buildCarousel(context, branches)
            : _buildList(context, branches);
      },
    );
  }

  Widget _buildCarousel(
    BuildContext context,
    List<Map<String, dynamic>> branches,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: context.screenHeight * .61,
            viewportFraction: 1,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),

          items: branches.asMap().entries.map((entry) {
            final index = entry.key;
            final branch = Branch.fromJson(entry.value);

            return Builder(
              builder: (BuildContext context) {
                return card(branch: branch);
              },
            );
          }).toList(),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: _goBack,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: HexColor('#3A3C40'),
                ),
                child: Center(child: SvgPicture.asset(AppImages.megarefresh)),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: _goForward,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: HexColor('#3A3C40'),
                ),
                child: Center(child: SvgPicture.asset(AppImages.outlineright)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, List<Map<String, dynamic>> branches) {
    return SingleChildScrollView(
      child: Column(
        spacing: 31,
        children: branches.asMap().entries.map((entry) {
          final index = entry.key;
          final branch = Branch.fromJson(entry.value);

          return Builder(
            builder: (BuildContext context) {
              return card(branch: branch);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget card({required Branch branch}) {
    final appWrite = context.read<AppwriteAuthProvider>();

    return Container(
      height: 545,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HexColor('#40444B'),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 135,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage(AppImages.image2),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              Container(
                height: 135,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        branch.headerImage != null &&
                            branch.headerImage!.isNotEmpty
                        ? CachedNetworkImageProvider(branch.headerImage!)
                        : const AssetImage("assets/images/image2.png")
                              as ImageProvider,
                  ),
                ),
              ),

              SizedBox(height: 55),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.branchName ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),

                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          branch.location ?? '',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),

                        Text(
                          '10min away',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: HexColor('#2C9043'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 9,
                      children: [
                        Text(
                          'Select a product to Schedule order',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#99FFFFFF'),
                          ),
                        ),

                        FutureBuilder<List<Product>>(
                          future: appWrite.loadBranchProducts(
                            branchId: branch.branchId,
                          ),

                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 140,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return SizedBox(
                                height: 140,
                                child: Center(
                                  child: Text("Failed to load products"),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return SizedBox(
                                height: 140,
                                child: Center(
                                  child: Text("No products available"),
                                ),
                              );
                            }

                            final products = snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.hardEdge,
                              child: Row(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: products.asMap().entries.map((entry) {
                                  final index = entry.key;

                                  final product = products[index];

                                  return Column(
                                    children: [
                                      Container(
                                        width: 83,
                                        height: 83,
                                        decoration: BoxDecoration(
                                          color: HexColor('#292B2F'),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              product.productImage,
                                            ),
                                            // const AssetImage(
                                            //         "assets/images/image2.png",
                                            //       )
                                            //       as ImageProvider,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 11),

                                      Text(
                                        'GHS 20.00',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      SizedBox(height: 13),

                                      Row(
                                        spacing: 5,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AppImages.starhalf),
                                          Text(
                                            '4 star rating',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 41),

                    Button(
                      buttonText: 'Schedule Order',
                      fontSize: 18,
                      borderRadius: 20,
                      height: 46,
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            left: 120,
            top: 90,
            child: Container(
              width: 100,
              height: 97,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: HexColor('#292B2F'),
                border: Border.all(width: 6, color: HexColor('#40444B')),
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
        ],
      ),
    );
  }
}
