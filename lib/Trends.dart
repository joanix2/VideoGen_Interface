import 'dart:convert';

import 'package:flutter/material.dart';
import 'config.dart';
import 'drawer.dart';
import 'utilities.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendsPage extends StatelessWidget {
  final String token;

  const TrendsPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Trends'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'News'),
                  Tab(text: 'Youtube'),
                ],
              ),
            ),
            drawer: CustomDrawer(token: token,),
            body: const TabBarView(
              children: [
                TrendsWidget(),
                TrendsWidget()
              ],
            )
        ),
    );
  }
}

class TrendsWidget extends StatefulWidget {
  const TrendsWidget({super.key});

  @override
  TrendsWidgetState createState() => TrendsWidgetState();
}

class TrendsWidgetState extends State<TrendsWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CustomContainer(
                  pad: pad,
                  color: Colors.grey.shade300,
                  child: const NewsArticlesWidget(),
                )
              ),
              Expanded(
                child: CustomContainer(
                  pad: pad,
                  color: Colors.grey.shade300,
                  child: const PieChartWidget(
                    data: {
                      'Catégorie A': 30,
                      'Catégorie B': 50,
                      'Catégorie C': 20,
                    },
                    colors: [Colors.blue, Colors.green, Colors.orange],
                    legend: ['A', 'B', 'C'],
                  ),
                )
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomContainer(
            pad: pad,
            color: Colors.grey.shade300,
            child: const Column(
              children: [
                TextField(

                )
              ],
            ),
          )
        ),
      ],
    );
  }
}

class NewsArticlesWidget extends StatefulWidget {
  const NewsArticlesWidget({super.key});

  @override
  NewsArticlesWidgetState createState() => NewsArticlesWidgetState();
}

class NewsArticlesWidgetState extends State<NewsArticlesWidget> {
  List<dynamic> articles = [];

  get http => null;

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
      });
    } else {
      throw Exception('Échec du chargement des articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Derniers Articles de News', style: title1,),
        Expanded(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(article['title'] ?? ''),
                subtitle: Text(article['description'] ?? ''),
              );
            },
          ),
        )
      ],
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;
  final List<Color> colors;
  final List<String> legend;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.colors,
    required this.legend,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: List<PieChartSectionData>.generate(
            data.length,
                (index) {
              return PieChartSectionData(
                color: colors[index],
                value: data.values.elementAt(index).toDouble(),
                title: data.keys.elementAt(index),
                radius: 45,
              );
            },
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }
}
