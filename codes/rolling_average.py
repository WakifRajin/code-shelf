from typing import Iterable, List


def rolling_average(values: Iterable[float], window: int = 3) -> List[float]:
    """Return moving averages using a fixed-size trailing window."""
    if window <= 0:
        raise ValueError("window must be positive")

    values = list(values)
    if not values:
        return []

    result: List[float] = []
    running_sum = 0.0

    for i, value in enumerate(values):
        running_sum += value
        if i >= window:
            running_sum -= values[i - window]

        divisor = min(i + 1, window)
        result.append(running_sum / divisor)

    return result
