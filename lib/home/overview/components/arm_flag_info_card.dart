import 'package:flutter/material.dart';
import 'package:inavconfigurator/home/overview/bloc/arm_flag_bloc.dart';

import '../constants.dart';

class ArmFlagInfoCard extends StatelessWidget {
  const ArmFlagInfoCard({
    Key? key,
    required this.armFlag,
  }) : super(key: key);

  final ArmFlag armFlag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 16,
                width: 16,
                // decoration: BoxDecoration(
                //   color: armFlag.color!.withOpacity(0.1),
                //   borderRadius: const BorderRadius.all(Radius.circular(10)),
                // ),
                // child: SvgPicture.asset(
                //   armFlag.svgSrc!,
                //   color: armFlag.color,
                // ),
              ),
              Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            armFlag.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // ProgressLine(
          //   color: armFlag.color,
          //   percentage: armFlag.percentage,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${armFlag.enabled} ",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white70),
              ),
              if (!armFlag.enabled)
                Icon(Icons.error_outline, color: Colors.red)
              else
                Icon(Icons.check_circle, color: Colors.green)

              // Text(
              //   armFlag.enabled!,
              //   style: Theme.of(context)
              //       .textTheme
              //       .caption!
              //       .copyWith(color: Colors.white),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
