import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/errorbanner_bloc.dart';

class ErrorWrapper extends StatelessWidget {
  const ErrorWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErrorBannerBloc, ErrorBannerState>(
      builder: (context, state) {
        if (state.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MaterialBanner(
                content: Text(state.errorMessage),
                leading: Icon(Icons.error),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<ErrorBannerBloc>(context)
                            .add(CloseErrorBannerEvent());
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              this.child
            ],
          );
        }

        return this.child;
      },
    );
  }
}
