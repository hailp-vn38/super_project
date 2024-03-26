async function chapter(url) {
  var res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  var result = [];

  const regex = /_video_player\.innerHTML\s*=\s*'([^']+)'/g;
  const matches = [...res.matchAll(regex)].map((match) => match[1]);

  for (var i = 0; i < matches.length; i++) {
    var item = matches[i];
    var el = await Extension.getAttributeText(item, "iframe", "src");
    if (el) {
      result.push({
        server_name: `SERVER-${i + 1}`,
        data: el,
        type: "iframe",
      });
    }
  }

  return Response.success(result);
}

// runFn(() =>
//   chapter("https://animehay.me/xem-phim/tran-hon-nhai-phan-3-tap-9-58893.html")
// );
