import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/03_user_profile/ui/widget/manage_intrests_tags_widget.dart';
import 'package:synopse/features/04_home/bloc/tree_tags/tree_tags_bloc.dart';

class ManageIntrestsTags extends StatelessWidget {
  final int tagId;
  final List<int> userIntrestTags;

  const ManageIntrestsTags(
      {super.key, required this.tagId, required this.userIntrestTags});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TreeTagsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ManageIntrests(
        tagId: tagId,
        userIntrestTags: userIntrestTags,
      ),
    );
  }
}

class ManageIntrests extends StatefulWidget {
  final int tagId;

  final List<int> userIntrestTags;

  const ManageIntrests(
      {super.key, required this.tagId, required this.userIntrestTags});
  @override
  State<ManageIntrests> createState() => _ManageIntrestsState();
}

class _ManageIntrestsState extends State<ManageIntrests> {
  @override
  void initState() {
    super.initState();
    context
        .read<TreeTagsBloc>()
        .add(TreeTagsFetch(tagHierarchyId: widget.tagId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreeTagsBloc, TreeTagsState>(
      builder: (context, treeTagsState) {
        if (treeTagsState.status == TreeTagsStatus.success) {
          return Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0, // Adjust the spacing between wraps
              runSpacing: 8.0, // Adjust the spacing between lines of wraps
              children: treeTagsState.synopseArticlesTV4TagsHierarchyTree
                  .map((treeTags) {
                final bool isUserIntrested =
                    widget.userIntrestTags.contains(treeTags.tagId);
                return UserTags111(
                  tagId: treeTags.tagId,
                  tagName: treeTags.tag,
                  isUserIntrest: isUserIntrested,
                );
              }).toList(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
