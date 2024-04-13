async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status == "success")
    return Response.error("Có lỗi khi tải nội dung");

  const detail = res.data.item;

  var chapters = [];
  if (detail.episodes != 0) {
    var server_name = detail.episodes[0].server_name;
    for (const item of detail.episodes[0].server_data) {
      chapters.push({
        name: item.name,
        url: item.link_embed,
        movies: [
          {
            server_name: server_name,
            data: item.link_m3u8,
            type: "file",
          },
        ],
      });
    }
  }
  return Response.success(chapters);
}

// runFn(() => chapters("https://ophim1.com/v1/api/phim/du-phuong-hanh"));
