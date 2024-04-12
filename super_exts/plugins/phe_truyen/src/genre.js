async function genre(url) {
  const res = await Extension.request(url + "/index.php/category/action");
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(res, "#category option");
  let result = [];
  for (const element of listEl) {
    result.push({
      title: (
        await Extension.querySelector(element.content, "option").text
      ).trim(),
      url: await Extension.getAttributeText(element.content, "option", "value"),
    });
  }
  return Response.success(result);
}

// runFn(() => genre("https://phetruyen.vip"));
