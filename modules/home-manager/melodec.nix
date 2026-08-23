{ config, ... }:
{
  programs.melodec = {
    enable = true;
    musicPath = "${config.home.homeDirectory}/Music";
    keepUndeclared = false;
    tracks = [
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
        url = "https://www.youtube.com/playlist?list=PLwdf1V-z-tvK5t4_VCiJSZebemrg-fTid";
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
