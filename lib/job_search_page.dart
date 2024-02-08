import 'package:flutter/material.dart';

class JobSearchPage extends StatefulWidget {
  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final _searchController = TextEditingController();
  List<String> _jobList = [];

  void _searchJobs() {
    setState(() {
      _jobList = List<String>.generate(10, (index) => 'Job ${index + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search jobs',
                suffixIcon: IconButton(
                  onPressed: _searchJobs,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _jobList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_jobList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}