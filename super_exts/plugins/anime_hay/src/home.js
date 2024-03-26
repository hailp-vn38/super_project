async function home(url, page) {
  if (!page) page = 1;
  url = url.replace(".html", "");
  url = url + `/trang-${page}.html`;

  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");
  const lstEl = await Extension.querySelectorAll(res, "div.movie-item");
  const result = [];

  for (const item of lstEl) {
    const html = item.content;
    result.push({
      name: (await Extension.querySelector(html, ".name-movie").text).trim(),
      url: await Extension.getAttributeText(html, "a", "href"),
      description: await await Extension.querySelector(
        html,
        "div.episode-latest span"
      ).text,
      cover: await Extension.getAttributeText(html, "img", "src"),
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://animehay.me/phim-moi-cap-nhap"));
