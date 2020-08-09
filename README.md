# PM Communication Library Common

## License

    PMComm Common Library provides an R6RS library interface for operations common
    to both clients and emulators for reading and programming PentaMetric devices
    by Bogart Engineering over the network (Ethernet/IP/TCP stack).
    Copywrite (C) 2020 Guy P. Gastineau

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program (`license.txt`).  If not, see <https://www.gnu.org/licenses/>.

## Purpose
Rather than bind to the aging libpmcomm released by Bogart Engineering by John somebody (john@bogartengineering.com and hosted on GitHub at https://github.com/jMyles/pmcomm), this project defines a portable pure R6RS library interface for creating clients, emulators, or automating communication, including reading real-time and periodic data and programming, for the PentaMetric devices by Bogart Engineering.  At least initially, this common library should be used to make an emulator that can be tested by accessing it with the outdated PMCOMM software linked above. Maybe if we can get a real datasheet from Bogart Engineering, then we can make a formall test suite and specification, but making one out of the old software accessing this one as an emulator might be the best we can do getting started.
