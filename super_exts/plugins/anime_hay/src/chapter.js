async function chapter(url) {
  var res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  var result = [];

  const regex = /_video_player\.innerHTML\s*=\s*'([^']+)'/g;
  const matches = [...res.matchAll(regex)].map((match) => match[1]);

  function getIdFromUrlWithRegex(url) {
    // Biểu thức chính quy để khớp với phần ID trong URL
    const idRegex = /id=(?<id>[a-z0-9]+)/i;

    // Tìm kiếm khớp với biểu thức chính quy trong URL
    const match = idRegex.exec(url);

    // Nếu tìm thấy khớp, trả về giá trị ID
    if (match) {
      return match.groups.id;
    } else {
      // Không tìm thấy ID, trả về null
      return null;
    }
  }

  for (var i = 0; i < matches.length; i++) {
    var item = matches[i];

    var el = await Extension.getAttributeText(item, "iframe", "src");
    console.log(getIdFromUrlWithRegex(el));

    if (el) {
      var id = getIdFromUrlWithRegex(el);
      if (el.includes("pho.php") && id) {
        var id = getIdFromUrlWithRegex(el);
        result = [
          {
            server_name: `PHO`,
            data: `https://pt.rapovideo.xyz/playlist/${id}/master.m3u8`,
            type: "file",
          },
          ...result,
        ];
      } else {
        result.push({
          server_name: `SERVER-${i + 1}`,
          data: el,
          type: "iframe",
        });
      }
    }
  }

  return Response.success(result);
}

runFn(() =>
  chapter(
    "https://animehay.blog/xem-phim/tran-hon-nhai-phan-3-tap-9-58893.html"
  )
);

// File m3u8 https://pt.rapovideo.xyz/playlist/id/master.m3u8
//
// https://rapovideo.xyz/playlist/6615eb0a13e90edd176c6330/master.m3u8
