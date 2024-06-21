import 'package:flutter/material.dart';
import 'package:tpm_late_game/connection/api_data_source.dart';
import 'package:tpm_late_game/models/list_user.dart';
import 'package:tpm_late_game/pages/page_user_detail.dart';

class PageListUsers extends StatefulWidget {
  final int index;
  const PageListUsers({super.key, required this.index});

  @override
  State<PageListUsers> createState() => _PageListUsersState();
}

class _PageListUsersState extends State<PageListUsers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'List Users',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: _buildListUsersBody(widget.index)),
    );
  }

  Widget _buildListUsersBody(int index) {
    return FutureBuilder(
      future: ApiDataSource.loadUsers(index),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          ListUsers listUser = ListUsers.fromJson(snapshot.data);
          return _buildSuccessSection(listUser);
        }
        return _buildLoadingSection();
      },
    );
  }

  Widget _buildErrorSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("An Error Occured."),
        ],
      ),
    );
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }

  Widget _buildSuccessSection(ListUsers data) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _buildItemUsers(data.data![index]);
            },
            itemCount: data.data!.length,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buttonPage(1),
            const SizedBox(width: 7.5),
            _buttonPage(2),
          ],
        ),
        // Add your additional widget here
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildItemUsers(Data userData) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PageUserDetails(
                id: userData.id!,
              );
            },
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      image: DecorationImage(
                          image: NetworkImage(userData.avatar!),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Username
                      Text(
                        '${userData.firstName!} ${userData.lastName!}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      //email
                      Text(
                        userData.email!,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              //_favoriteButton()
              _followButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonPage(int index) {
    return SizedBox(
      width: 40, // Set the width to make it square
      height: 40, // Set the height to make it square
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PageListUsers(
                  index: index,
                );
              },
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xfffffbff),
          foregroundColor: Colors.black,
          side: const BorderSide(
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(7.5),
        ),
        child: Text(
          index.toString(),
        ),
      ),
    );
  }

  Widget _followButton(){
    return SizedBox(
      height: 40, // Set the height to make it square
      width: 100, 
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xfffffbff),
          foregroundColor: Colors.black,
          side: const BorderSide(
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(7.5),
        ),
        child: const Text(
          'Follow',
          style: TextStyle(fontWeight: FontWeight.w400)
        ),
      ),
    );
  }

  // Widget _favoriteButton(){
  //   return IconButton(icon: const Icon(Icons.favorite_border), onPressed: (){},);
  // }
}
