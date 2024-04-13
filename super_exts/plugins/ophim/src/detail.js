async function detail(book_url) {
  const res = await Extension.request(book_url);
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

  var genres = [];
  for (const item of detail.category) {
    genres.push({
      title: item.name,
      url: "/v1/api/the-loai/" + item.slug,
    });
  }

  return Response.success({
    name: detail.name,
    cover: res.data.seoOnPage.seoSchema.image,
    status: detail.status,
    author: detail.origin_name,
    description: detail.content,
    url: book_url,
    chapters,
    genres,
  });
}

// runFn(() => detail("https://ophim1.com/v1/api/phim/du-phuong-hanh"));
