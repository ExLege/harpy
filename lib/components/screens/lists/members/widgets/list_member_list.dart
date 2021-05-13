import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class ListMemberList extends StatelessWidget {
  const ListMemberList({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bloc = context.watch<ListMemberBloc>();
    final state = bloc.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: state.hasMoreData,
          onLoadMore: () async {
            bloc.add(const LoadMoreMembers());
            await bloc.requestMoreFuture;
          },
          child: UserList(
            state.members,
            beginSlivers: <Widget>[
              HarpySliverAppBar(
                title: list.name,
                floating: true,
              )
            ],
            endSlivers: <Widget>[
              if (state.isLoading)
                const SliverFillLoadingIndicator()
              else if (state.isFailure)
                SliverFillLoadingError(
                  message: const Text('error loading list members'),
                  onRetry: () => bloc.add(const ShowListMembers()),
                )
              else if (state.hasNoMembers)
                SliverFillLoadingError(
                  message: const Text('no members found'),
                  onRetry: () => bloc.add(const ShowListMembers()),
                ),
              if (state.loadingMore) const SliverBoxLoadingIndicator(),
              SliverToBoxAdapter(
                child: SizedBox(height: mediaQuery.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
