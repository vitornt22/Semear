import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:semear/blocs/search_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';

class ApiSearch {
  late SearchBloc searchBloc = BlocProvider.getBloc<SearchBloc>();
  late UserBloc userBloc = BlocProvider.getBloc<UserBloc>();

  getObject(category, value) {
    switch (category) {
      case 'project':
        return Project.fromJson(value);
      case 'missionary':
        return Missionary.fromJson(value);
      case 'donor':
        return Donor.fromJson(value);
      case 'church':
        return Church.fromJson(value);
      default:
    }
  }

  addResults(category, data, subcategory) {
    switch (category) {
      case 'project':
        if (subcategory == 'getTopProjects') {
          searchBloc.inTopProjects.add(data);
        } else {
          searchBloc.inProjects.add(data);
        }
        break;
      case 'missionary':
        if (subcategory == 'getTopProjects') {
          searchBloc.inTopMissionaries.add(data);
        } else {
          searchBloc.inMissionaries.add(data);
        }
        break;
      case 'donor':
        searchBloc.inDonors.add(data);
        break;
      case 'church':
        searchBloc.inChurchs.add(data);
        break;
      default:
    }
  }

  Future<Map<String, dynamic>?> getPageRankProjects(category, query) async {
    final link = query != ''
        ? "https://backend-semear.herokuapp.com/user/api/$category/?search=${query}"
        : "https://backend-semear.herokuapp.com/user/api/$category/";

    print(link);
    http.Response response = await http.get(Uri.parse(link));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var user;
      var data;
      var projects;

      searchBloc.inLoading.add(true);
      if (category == 'getSuggestions') {
        print('entrou');
        final lista = json.decode(response.body).map((value) {
          value.remove('pageRank');
          user = User.fromJson(value["user"]);
          data = getObject(value["user"]["category"], value["userData"]);
          userBloc.addUser(user);
          userBloc.addCategory(user.id, data);
          return data;
        }).toList();
        print(lista);
        searchBloc.inSuggestions.add(lista);
      } else {
        json.decode(response.body).entries.forEach(
          (entry) {
            projects = entry.value.map((value) {
              value.remove('pageRank');
              user = User.fromJson(value["user"]);
              data = getObject(entry.key, value["userData"]);
              userBloc.addUser(user);
              userBloc.addCategory(user.id, data);
              return data;
            }).toList();

            addResults(entry.key, projects, category);

            // print(jsonEncode(projects));
          },
        );
      }
    }
    searchBloc.inLoading.add(false);

    print('RETORNANDO NULL HERE');

    return null;
  }
}
