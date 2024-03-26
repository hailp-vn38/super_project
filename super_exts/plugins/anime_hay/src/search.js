async function search(url, kw, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url + `/tim-kiem/${kw}/trang-${page}.html`;
  } else {
    url = url + `/tim-kiem/${kw}.html`;
  }
  const res = await Extension.request(url, {
    queryParameters: {
      q: kw,
    },
  });
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

// runFn(() => search("https://animehay.me", "tu tien"));
