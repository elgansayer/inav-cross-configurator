import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/home/overview/bloc/arm_flag_bloc.dart';
import 'package:inavconfigurator/home/overview/constants.dart';
import 'arm_flag_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreArmChecks extends StatelessWidget {
  const PreArmChecks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.preArmChecks,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
        SizedBox(height: defaultPadding),
        _listView(),
        // Responsive(
        //   mobile: ArmFlagInfoCardGridView(
        //     crossAxisCount: _size.width < 650 ? 2 : 4,
        //     childAspectRatio: _size.width < 650 ? 1.3 : 1,
        //   ),
        //   tablet: ArmFlagInfoCardGridView(),
        //   desktop: ArmFlagInfoCardGridView(
        //     childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
        //   ),
        // ),
      ],
    );
  }

  _listView() {
    return BlocBuilder<ArmFlagBloc, ArmFlagState>(
      builder: (context, state) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.armFlags.length,
          itemBuilder: (context, index) {
            ArmFlag armFlag = state.armFlags.elementAt(index);

            Icon icon = (!armFlag.enabled)
                ? Icon(Icons.error_outline, color: Colors.red)
                : Icon(Icons.check_circle, color: Colors.green);

            String name = AppLocalizations.of(context)!.armChecks(armFlag.name);

            return ListTile(
              leading: Icon(Icons.info),
              title: Text(name),
              trailing: icon,
            );
          },
        );
      },
    );
  }
}

class ArmFlagInfoCardGridView extends StatelessWidget {
  const ArmFlagInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArmFlagBloc, ArmFlagState>(
      builder: (context, state) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.armFlags.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) =>
              ArmFlagInfoCard(armFlag: state.armFlags.elementAt(index)),
        );
      },
    );
  }
}
