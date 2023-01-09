{ lib
, aiofiles
, aiohttp
, aioshutil
, buildPythonPackage
, dateparser
, fetchFromGitHub
, ipython
, orjson
, packaging
, pillow
, poetry-core
, pydantic
, pyjwt
, pytest-aiohttp
, pytest-asyncio
, pytest-benchmark
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, python-dotenv
, pythonOlder
, pytz
, setuptools
, termcolor
, typer
, ffmpeg
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "4.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-D7XIq9uwb3SaVa6NW4jDFeK73zsf51EG+5EkqgGlxCo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=pyunifiprotect --cov-append" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    aioshutil
    dateparser
    orjson
    packaging
    pillow
    pydantic
    pyjwt
    pytz
    typer
  ] ++ typer.optional-dependencies.all;

  passthru.optional-dependencies = {
    shell = [
      ipython
      python-dotenv
      termcolor
    ];
  };

  checkInputs = [
    ffmpeg # Required for command ffprobe
    pytest-aiohttp
    pytest-asyncio
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyunifiprotect"
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  meta = with lib; {
    description = "Library for interacting with the Unifi Protect API";
    homepage = "https://github.com/briis/pyunifiprotect";
    changelog = "https://github.com/AngellusMortis/pyunifiprotect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
