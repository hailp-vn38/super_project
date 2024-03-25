async function detail(book_url) {
  const res = await Extension.request(book_url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status) return Response.error("Có lỗi khi tải nội dung");

  // chapters

  var chapters = [];
  if (res.episodes.length != 0) {
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
  }

  return Response.success({
    name: res.movie.name,
    cover: res.movie.poster_url,
    status: res.movie.status,
    author: res.movie.origin_name,
    description: res.movie.content,
    url: book_url,
    chapters,
  });
}

// runFn(() => detail("https://phimapi.com/phim/the-age-of-cosmos-exploration"));
