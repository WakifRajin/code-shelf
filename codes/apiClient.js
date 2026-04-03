async function requestJson(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {
      Accept: "application/json",
      ...(options.headers || {})
    }
  });

  const text = await response.text();
  const data = text ? JSON.parse(text) : null;

  if (!response.ok) {
    const message = data && data.message ? data.message : `Request failed with ${response.status}`;
    throw new Error(message);
  }

  return data;
}

export { requestJson };
