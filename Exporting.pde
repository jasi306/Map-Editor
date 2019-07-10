
void export(){
  System.out.print("number of nods  "+pointsCounter+'\n');
  System.out.print("number of links "+linksCounter+'\n');

  for(int i=0;i<pointsCounter;++i){
    for(int j=0;j<linksCounter;++j){
      if(links[j].p1==points[i]){
        int k;
        for(k=0;k<pointsCounter;++k) if(links[j].p2==points[k]) break;
        System.out.print(i+" "+k+" "+distance_between(points[i],points[k])/distance_const);
        System.out.print('\n');
      }
    }
  }
}
