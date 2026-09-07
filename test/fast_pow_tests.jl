using FastPower: fastpower
using Test

@test fastpower(1, 1) isa Float64
@test fastpower(1.0, 1.0) isa Float64

# Dense grids below allocate O(nx*ny) Float64s. On 32-bit the product length /
# allocation size overflows Int32 (`invalid GenericMemory size`), so use a
# coarser grid when WORD_SIZE != 64 while still covering the same domains.
const X_FINE = Sys.WORD_SIZE == 64 ? (0.001:0.001:1) : (0.001:0.01:1)
const Y_FINE = Sys.WORD_SIZE == 64 ? (0.08:0.001:0.5) : (0.08:0.01:0.5)
const Y_WIDE = Sys.WORD_SIZE == 64 ? (0.08:0.001:1000.0) : (0.08:0.05:1000.0)
const X_WIDE = Sys.WORD_SIZE == 64 ? (0.001:0.001:100) : (0.001:0.05:100)
const Y_UNIT = Sys.WORD_SIZE == 64 ? (0.08:0.001:1.0) : (0.08:0.01:1.0)

errors = [abs(^(x, y) - fastpower(x, y)) for x in X_FINE, y in Y_FINE]
@test maximum(errors) < 1.0e-4

errors = [abs(^(x, y) - fastpower(x, y)) for x in X_FINE, y in Y_WIDE]
@test maximum(errors) < 1.0e-3

errors = [abs(^(x, y) - fastpower(x, y)) for x in X_WIDE, y in Y_UNIT]
@test maximum(errors) < 1.0e-2
