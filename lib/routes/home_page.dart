import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:github_client_app/common/github.dart';
import 'package:github_client_app/common/icons.dart';
import 'package:github_client_app/models/repo.dart';
import 'package:github_client_app/states/theme_model.dart';
import 'package:github_client_app/states/user_model.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  static const loading = "###loading###";
  final _items = <Repo>[Repo.empty(loading)];
  int page = 1;
  static const int pageSize = 20;
  bool hasMore = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).home),
      ),
      body: _buildBody(),
      drawer: const MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel user = Provider.of(context);
    if (!user.isLogin) {
      return Center(
        child: ElevatedButton(
          child: Text(AppLocalizations.of(context).login),
          onPressed: () => Navigator.of(context).pushNamed("login"),
        ),
      );
    }

    return ListView.separated(
        itemBuilder: (ctx, index) {
          if (_items[index].name != loading) {
            return RepoItem(repo: _items[index]);
          }
          if (hasMore) {
            _queryRepo();
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noRepo,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }
        },
        separatorBuilder: (ctx, index) => const Divider(
              height: .0,
            ),
        itemCount: _items.length);
  }

  void _queryRepo() async {
    var data = await Github(context).queryRepoes(queryParameters: {
      "page": page,
      "page_size": 10,
    });

    hasMore = data.isNotEmpty && data.length % pageSize == 0;

    setState(() {
      _items.insertAll(_items.length - 1, data);
      page++;
    });
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), Expanded(child: _buildMenu())],
          )),
    );
  }

  Widget _buildHeader() {
    return Consumer2<ThemeModel, UserModel>(builder:
        (BuildContext ctx, ThemeModel theme, UserModel user, Widget? child) {
      return GestureDetector(
        onTap: () {
          if (user.unLogin) {
            Navigator.of(ctx).pushNamed("login");
          }
        },
        child: Container(
          color: theme.theme,
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipOval(
                  child: user.isLogin
                      ? avatar(user.user!.avatarUrl, width: 80)
                      : Image.asset("imgs/avatar-default.png", width: 80),
                ),
              ),
              Text(
                user.isLogin
                    ? user.user!.login
                    : AppLocalizations.of(ctx).login,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenu() {
    return Consumer<UserModel>(
      builder: (BuildContext ctx, UserModel user, Widget? child) {
        var appLoc = AppLocalizations.of(ctx);
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(appLoc.theme),
              onTap: () => Navigator.of(ctx).pushNamed("themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(appLoc.language),
              onTap: () => Navigator.of(ctx).pushNamed("language"),
            ),
            if (user.isLogin)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: Text(appLoc.logout),
                onTap: () {
                  showDialog(
                      context: ctx,
                      builder: (ctx) {
                        return AlertDialog(
                          content: Text(appLoc.logoutTip),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text(appLoc.cancel)),
                            TextButton(
                                onPressed: () {
                                  user.user = null;
                                  Navigator.of(ctx).pop();
                                },
                                child: Text(appLoc.yes)),
                          ],
                        );
                      });
                },
              )
          ],
        );
      },
    );
  }
}

class RepoItem extends StatefulWidget {
  RepoItem({required this.repo}) : super(key: ValueKey(repo.id));

  final Repo repo;

  @override
  State<StatefulWidget> createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Material(
        color: Colors.white,
        shape: BorderDirectional(
            bottom:
                BorderSide(color: Theme.of(context).dividerColor, width: .5)),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                leading: avatar(widget.repo.owner.avatarUrl,
                    width: 24, borderRadius: BorderRadius.circular(12)),
                title: Text(
                  widget.repo.owner.login,
                  textScaler: const TextScaler.linear(.9),
                ),
                subtitle: Text(
                  widget.repo.owner.bio ?? '',
                  textScaler: const TextScaler.linear(.9),
                ),
                trailing: Text(widget.repo.language ?? '--'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.repo.fork
                          ? widget.repo.fullName
                          : widget.repo.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: widget.repo.fork
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: widget.repo.description == null
                          ? Text(
                              AppLocalizations.of(context).noRepoDesc,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            )
                          : Text(
                              widget.repo.description!,
                              maxLines: 3,
                              style: TextStyle(
                                  height: 1.15,
                                  color: Colors.blueGrey[700],
                                  fontSize: 13),
                            ),
                    )
                  ],
                ),
              ),
              _buildBottom()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    const paddingWidth = 10;
    return IconTheme(
        data: const IconThemeData(color: Colors.grey, size: 15),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Builder(
              builder: (ctx) {
                var chirldren = <Widget>[
                  const Icon(Icons.star),
                  Text(
                      " ${widget.repo.stargazersCount.toString().padRight(paddingWidth)}"),
                  const Icon(Icons.info_outline),
                  Text(
                      " ${widget.repo.openIssuesCount.toString().padRight(paddingWidth)}"),
                  const Icon(MyIcons.fork),
                  Text(
                      " ${(widget.repo.forksCount).toString().padRight(paddingWidth)}"),
                ];

                if (widget.repo.fork) {
                  chirldren.add(Text("Forked".padRight(paddingWidth)));
                }

                if (widget.repo.private) {
                  chirldren.addAll([
                    const Icon(Icons.lock),
                    Text(" private".padRight(paddingWidth)),
                  ]);
                }

                return Row(
                  children: chirldren,
                );
              },
            ),
          ),
        ));
  }
}

Widget avatar(String url,
    {double width = 30,
    double? height,
    BoxFit? fit,
    BorderRadius? borderRadius}) {
  var placeholder = Image.asset(
    "imgs/avatar-default.png",
    width: width,
    height: height,
  );

  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    ),
  );
}
