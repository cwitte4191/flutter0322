import 'dart:async';

import 'package:flutter0322/network/GetS3Object.dart';
import 'package:semaphore/semaphore.dart';
class RefreshStatus{
  static final int  maxCount = 1;
  var running = 0;
  final int  simultaneous = 0;
  final LocalSemaphore sem;
  RefreshStatus():sem= new LocalSemaphore(maxCount)
  {

  }
  Future<Null> doRefresh({RaceConfig raceConfig})async{
    print("doRefresh0");
    int t0=DateTime.now().millisecondsSinceEpoch;

    await sem.acquire();

    int t1=DateTime.now().millisecondsSinceEpoch;
    int waitTime1=t1-t0;
    print("doRefresh1 $waitTime1 ");
    running++;
    await new RefreshData().doRefresh(raceConfig: raceConfig);
    running--;
    sem.release();
    int t2=DateTime.now().millisecondsSinceEpoch;
    int waitTime2=t2-t0;

    print("doRefresh2: $waitTime2");

    return;
  }
  bool isRefreshInProgress(){
    return( running>0);
  }
}