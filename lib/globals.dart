library globals;

import 'network/GetS3Object.dart';


bool isLoggedIn = false;
RaceConfig raceConfig=null;

RefreshData rdGlobal; //test refresh premature death. gc issue?