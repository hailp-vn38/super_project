async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url + `/${page}`;
  }

  const res = await Extension.request(url);

  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const lstEl = await Extension.querySelectorAll(
    res,
    "div.recoment_box div.story_item"
  );
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var bookUrl = await Extension.getAttributeText(
      html,
      "div.mg_name a",
      "href"
    );
    var description = await await Extension.querySelector(
      html,
      "div.mg_chapter div.chapter_count a"
    ).text;

    result.push({
      name: await Extension.querySelector(html, "div.mg_name a").text,
      url: bookUrl,
      description: description != null ? description.trim() : "",
      cover: await Extension.getAttributeText(html, "img", "src"),
    });
  }

  return Response.success(result);
}

// runFn(() => home("https://manga18.club"));
