async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status || res.episodes.length == 0)
    return Response.error("Có lỗi khi tải nội dung");

  const chapters = [];
  for (const item of res.episodes[0].server_data) {
    chapters.push({
      name: item.name,
      url: item.link_embed,
      movies: [
        {
          server_name: res.episodes[0].server_name,
          data: item.link_embed,
          type: "iframe",
        },
      ],
    });
  }
  return Response.success(chapters);
}

// runFn(() => chapters("https://phimapi.com/phim/the-age-of-cosmos-exploration"));
