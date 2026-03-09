- [ISBN13 Barcode Check Digit Generation](#isbn13-barcode-check-digit-generation)
  - [Implementation](#implementation)
  - [Format](#format)
  - [EAN](#ean)
  - [Process Chart](#process-chart)


# ISBN13 Barcode Check Digit Generation
[Replaced the ISBN10 protocol in 2007](https://en.wikipedia.org/wiki/ISBN#cite_note-conversion-6)

## Implementation
Per the business rules set out in the [spec](https://circlepos.com/jobs/), we're only generating a `check digit` not a `checksum`.

## Format
As the protocol name implies, the barcode is 13 digits long, _including the `check digit`_ (or `checksum` char)

## EAN
The 3-digit prefix for the ISBN13 barcode. Per [Wikipedia](https://en.wikipedia.org/wiki/ISBN#Overview), only `978` & `979` have been made available.

## Process Chart
```mermaid
    graph TD
    A[Check Barcode Length]
    B[Check Barcode Format]
    C[Check EAN validity]
    Error@{ shape: stadium, label: "Errors (on validity failure)" }
    subgraph D["Generate Check Digit"]
    direction TB
        E[Convert to String]
        F[Split to separate integers]
        G[Multiply odd-indexed ints by 3]
        H[Sum the digits]
        I["Divide by <code>10</code> and return _remainder_ (<code>modulo</code>)"]
        J["Minus _remainder_ from <code>10</code>"]
    E-->F
    F-->G
    G-->H
    H-->I
    I-->J
    end
    A-->B
    B-->C
    C-->D
    A-.->Error
    B-.->Error
    C-.->Error
```
