/* ****************************************************************** **
**    OpenFRESCO - Open Framework                                     **
**                 for Experimental Setup and Control                 **
**                                                                    **
**                                                                    **
** Copyright (c) 2006, Yoshikazu Takahashi, Kyoto University          **
** All rights reserved.                                               **
**                                                                    **
** Licensed under the modified BSD License (the "License");           **
** you may not use this file except in compliance with the License.   **
** You may obtain a copy of the License in main directory.            **
** Unless required by applicable law or agreed to in writing,         **
** software distributed under the License is distributed on an        **
** "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,       **
** either express or implied. See the License for the specific        **
** language governing permissions and limitations under the License.  **
**                                                                    **
** Developed by:                                                      **
**   Yoshikazu Takahashi (yos@catfish.dpri.kyoto-u.ac.jp)             **
**   Andreas Schellenberg (andreas.schellenberg@gmx.net)              **
**   Gregory L. Fenves (fenves@berkeley.edu)                          **
**                                                                    **
** ****************************************************************** */

// $Revision$
// $Date$
// $URL: $

// Written: Yoshi (yos@catfish.dpri.kyoto-u.ac.jp)
// Created: 09/06
// Revision: A
//
// Description: This file contains the implementation of ExpCPIter.

#include "ExpCPIter.h"

#include <ExperimentalCP.h>
#include <TaggedObjectIter.h>
#include <TaggedObjectStorage.h>


ExpCPIter::ExpCPIter(TaggedObjectStorage *theStorage)
    : myIter(theStorage->getComponents())
{
    // does nothing
}


ExpCPIter::~ExpCPIter()
{
    // does nothing
}


void ExpCPIter::reset(void)
{
    myIter.reset();
}


ExperimentalCP* ExpCPIter::operator()(void)
{
    // check if we still have ExperimentalCPs in the model
    // if not return 0, indicating we are done
    TaggedObject *theComponent = myIter();
    if(theComponent == 0)
        return 0;
    else {
        ExperimentalCP* result = (ExperimentalCP*)theComponent;
        return result;
    }
}
