{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, poetry-core
, setuptools
, wheel
, bleak
, pytestCheckHook
, bleak-retry-connector
, bluetooth-adapters
, bluetooth-auto-recovery
, bluetooth-data-tools
, home-assistant-bluetooth
, pythonOlder
}:

buildPythonPackage rec {
  pname = "habluetooth";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "habluetooth";
    rev = "refs/tags/v${version}";
    hash = "sha256-LCTVU73gN82U9uVYU8FkuovdWcZY4WDtLhh+F+E6QM0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=habluetooth --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    bluetooth-adapters
    bluetooth-auto-recovery
    bluetooth-data-tools
    home-assistant-bluetooth
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "habluetooth"
  ];

  meta = with lib; {
    description = "Library for high availability Bluetooth";
    homepage = "https://github.com/Bluetooth-Devices/habluetooth";
    changelog = "https://github.com/Bluetooth-Devices/habluetooth/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
