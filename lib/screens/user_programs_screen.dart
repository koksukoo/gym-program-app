import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/programs.dart';
import '../widgets/app_drawer.dart';
import './edit_program_screen.dart';

enum ProgramActions { Edit, Active, Delete }

class UserProgramsScreen extends StatefulWidget {
  static const routeName = '/user-programs';

  @override
  _UserProgramsScreenState createState() => _UserProgramsScreenState();
}

class _UserProgramsScreenState extends State<UserProgramsScreen> {
  final String _active = null;

  Future<void> _refreshPrograms(context) async {
    await Provider.of<Programs>(context, listen: false).refreshPrograms();
  }

  Future<void> _deleteProgram(context, String id) async {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('This can not be undone'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<Programs>(context, listen: false).delete(id);
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Delete Program',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ));
  }

  @override
  void initState() {
    Provider.of<Programs>(context, listen: false).refreshPrograms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final programs = Provider.of<Programs>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Gym Programs'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProgramScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: RefreshIndicator(
          child: ListView.builder(
            itemCount: programs.length,
            itemBuilder: (ctx, i) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FittedBox(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${programs[i].cycles}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text('weeks'),
                        ],
                      ),
                    ),
                  ),
                ),
                title: Text(programs[i].name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.star_border), onPressed: null),
                    PopupMenuButton<ProgramActions>(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                            child: Text('Set Active'),
                            value: ProgramActions.Active),
                        PopupMenuItem(
                            child: Text('Edit Program'),
                            value: ProgramActions.Edit),
                        PopupMenuItem(
                            child: Text('Delete Program'),
                            value: ProgramActions.Delete),
                      ],
                      onSelected: (ProgramActions value) {
                        switch (value) {
                          case ProgramActions.Active:
                            //
                            break;
                          case ProgramActions.Edit:
                            Navigator.of(context).pushNamed(
                                EditProgramScreen.routeName,
                                arguments: programs[i].id);
                            break;
                          default:
                            _deleteProgram(context, programs[i].id);
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(EditProgramScreen.routeName,
                      arguments: programs[i].id);
                },
              ),
            ),
          ),
          onRefresh: () => _refreshPrograms(context),
        ),
      ),
    );
  }
}
