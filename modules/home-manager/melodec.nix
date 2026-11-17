{ config, ... }:
{
  programs.melodec = {
    enable = true;
    musicPath = config.xdg.userDirs.music;
    keepUndeclared = false;
    tracks = [
      {
        url = "https://www.youtube.com/watch?v=F5D04udwezc";
        author = "CUPSIZE";
        title = "В окно с тобой";
      }
      {
        url = "https://soundcloud.com/wwoowwoo/villian-madk1d-dinastiia";
        author = "VILLIAN, madk1d";
        title = "ДИНАСТИЯ";
      }
      {
        url = "https://soundcloud.com/olezhka-koshil/morgenshtern-cadilac";
        author = "MORGENSHTERN & Элджей";
        title = "Cadilac";
      }
      {
        url = "https://soundcloud.com/linalifonova/wishlist?in=linalifonova/sets/prygaiduravishlist";
        author = "CUPSIZE";
        title = "вишлист";
      }
      {
        url = "https://soundcloud.com/humanoid-977641388/peredoz-2";
        author = "CUPSIZE";
        title = "передоз";
      }
    ];
    playlists = [
      {
        url = "https://soundcloud.com/alisherhateu/sets/alisher-alisher";
        author = "MORGENSHTERN";
        title = "ALISHER";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/dead-sea-live-acoustic-live";
        author = "MORGENSHTERN";
        title = "Dead Sea Live (Acoustic Live)";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/last-one";
        author = "MORGENSHTERN";
        title = "Last one";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/mdb";
        author = "MORGENSHTERN";
        title = "MILLION DOLLAR: BUSINESS";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/mdh";
        author = "MORGENSHTERN";
        title = "MILLION DOLLAR: HAPPINESS";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/piluga";
        author = "MORGENSHTERN";
        title = "ЛЕГЕНДАРНАЯ ПЫЛЬ";
      }
      {
        url = "https://soundcloud.com/alisherhateu/sets/smile";
        author = "MORGENSHTERN";
        title = "Улыбнись, дурак!";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/shh-1";
        author = "Kai angel";
        title = "Shh!";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/fakelove-angryy";
        author = "Kai angel";
        title = "fakelove / angryy";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/heavy-metal";
        author = "Kai angel & 9mice";
        title = "Heavy metal";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/kaicore";
        author = "Kai angel";
        title = "kAiCoRe";
      }
      {
        url = "https://soundcloud.com/deaddynastyph/sets/million-dollar-depression";
        author = "PHARAOH";
        title = "MILLION DOLLAR DEPRESSION";
      }
      {
        url = "https://soundcloud.com/deaddynastyph/sets/pravilo";
        author = "PHARAOH";
        title = "Правило";
      }
      {
        url = "https://soundcloud.com/creepypastak1ng/sets/militantum";
        author = "тёмный принц";
        title = "militantum";
      }
      {
        url = "https://soundcloud.com/17-seventeen-371237062/sets/pesochnyy-chelovek";
        author = "17SEVENTEEN";
        title = "Песочный человек";
      }
      {
        url = "https://soundcloud.com/17-seventeen-371237062/sets/gipnofobiya";
        author = "17SEVENTEEN";
        title = "Гипнофобия";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/shh";
        author = "Kai Angel";
        title = "Shh...";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/kai-angel-god-system";
        author = "Kai Angel";
        title = "GOD SYSTEM";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/heavy-metal-2-tyazhelyj-metall";
        author = "Kai Angel, 9mice";
        title = "Heavy metal 2";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/angel-may-cry";
        author = "Kai Angel";
        title = "Angel may cry";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/angel-may-cry-2";
        author = "Kai Angel";
        title = "Angel may cry 2";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/marilyn-manson";
        author = "Kai Angel";
        title = "Marilyn Manson";
      }
      {
        url = "https://soundcloud.com/kaiangel-9mice/sets/9mice-orpheus";
        author = "9mice";
        title = "ORPHEUS";
      }
      {
        url = "https://soundcloud.com/everlov3d/sets/cupsize-kak-isportit";
        author = "CUPSIZE";
        title = "Как испортить вечеринку?";
      }
      {
        url = "https://soundcloud.com/kai-angel-580741983/sets/immortal";
        author = "Kai Angel";
        title = "damage";
      }
      {
        url = "https://soundcloud.com/linalifonova/sets/zastav-menya-plakat";
        author = "CUPSIZE";
        title = "Заставь меня плакать";
      }
      {
        url = "https://soundcloud.com/6htexnw3yw1g/sets/cupsize-kazhetsya-v-adu";
        author = "CUPSIZE";
        title = "кажется, в аду прикольно, но меня выгнали б утром";
      }
      {
        url = "https://soundcloud.com/linalifonova/sets/v-moikh-legkikh-vyrosli-tsvety";
        author = "CUPSIZE";
        title = "в моих легких выросли цветы";
      }
      {
        url = "https://www.youtube.com/playlist?list=OLAK5uy_nT2X4xeypZ3RxFhaBVK3daf9sWvg2DDJs";
        author = "CUPSIZE";
        title = "дели на два";
      }
      {
        url = "https://soundcloud.com/humanoid42-sc/sets/ebi-menya-malyshka";
        author = "CUPSIZE";
        title = "Еби меня, малышка";
      }
      {
        url = "https://soundcloud.com/zavetvip_itskov/sets/gotika";
        author = "zavet";
        title = "gotika";
      }
      # {
      #   url = "";
      #   author = "";
      #   title = "";
      # }
      # {
      #   url = "";
      #   author = "";
      #   title = "";
      # }
      # {
      #   url = "";
      #   author = "";
      #   title = "";
      # }
    ];
  };
}
