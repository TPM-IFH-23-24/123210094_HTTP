import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tpm_late_game/connection/api_data_source.dart';
import 'package:tpm_late_game/models/detail_user.dart';

class PageUserDetails extends StatelessWidget {
  final int id;
  const PageUserDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: _buildUserDetails(id)),
    );
  }

  Widget _buildUserDetails(int id) {
    return FutureBuilder(
      future: ApiDataSource.userDetails(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          UserDetails userDetail = UserDetails.fromJson(snapshot.data);
          return _buildSuccessSection(userDetail.data!, context);
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

  Widget _buildSuccessSection(Data userData, context) {
    String level = userData.id!.toString();
    String firstName = userData.firstName!;
    String lastName = userData.lastName!;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //back
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.back)),
                  //share
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.share)),
                ],
              ),
              CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage(userData.avatar!),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  //name
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  //id(level)
                  Text(
                    'Level $level',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  //- static - role
                  const Text(
                    'Crypto advocate | Blockhain Explorer',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Column(
                          children: [
                            Text('543',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text("Followers", style: TextStyle(fontSize: 10))
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 60,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          children: [
                            Text('2k',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text("Likes", style: TextStyle(fontSize: 10))
                          ],
                        ),
                      ],
                    ),
                    FollowButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowed = false;
  void setFollow() {
    setState(() {
      isFollowed = !isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setFollow();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          minimumSize: Size(MediaQuery.of(context).size.width * .3, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
      child: Text(isFollowed ? 'Followed' : 'Follow', style: TextStyle(color: Colors.grey[200])),
    );
  }
}
