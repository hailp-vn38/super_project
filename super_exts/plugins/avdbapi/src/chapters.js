async function chapters(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const item = res.list[0];

  var chapters = [];
  if (item.episodes.length != 0) {
    for (const esp of Object.values(item.episodes.server_data)) {
      chapters.push({
        name: esp.slug,
        url: esp.link_embed,
        movies: [
          {
            server_name: item.episodes.server_name,
            data: esp.link_embed,
            type: "embed",
          },
        ],
      });
    }
  }
  return Response.success(chapters);
}

// runFn(() =>
//   chapters("https://avdbapi.com/api.php/provide/vod?ac=detail&ids=129903")
// );
