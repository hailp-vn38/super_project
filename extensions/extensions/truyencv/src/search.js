async function search(url, kw, page) {
  const res = await Extension.request(url + "/tim-truyen", {
    queryParameters: { page: page, q: kw },
  });

  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const list = await Extension.querySelectorAll(res, "div.media");
  const result = [];

  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(
      html,
      "div.story-thumb img",
      "src"
    );

    const book_url = await Extension.getAttributeText(
      html,
      "div.story-thumb a",
      "href"
    );
    result.push({
      name: await Extension.querySelector(html, "h4.media-heading a").text,
      description: await Extension.querySelector(html, "p.text-summary").text,
      cover,
      url: book_url,
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://truyencv.info","Tu",1));
