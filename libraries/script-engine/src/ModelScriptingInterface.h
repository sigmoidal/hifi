//
//  ModelScriptingInterface.h
//  libraries/script-engine/src
//
//  Created by Seth Alves on 2017-1-27.
//  Copyright 2017 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//


#ifndef hifi_ModelScriptingInterface_h
#define hifi_ModelScriptingInterface_h

#include <QtCore/QObject>
#include <QScriptValue>
#include <OBJWriter.h>
#include <model/Geometry.h>
#include "MeshProxy.h"

using MeshPointer = std::shared_ptr<model::Mesh>;

class ModelScriptingInterface : public QObject {
    Q_OBJECT

public:
    ModelScriptingInterface(QObject* parent);

    Q_INVOKABLE QString meshToOBJ(MeshProxy* const &in);
};

QScriptValue meshToScriptValue(QScriptEngine* engine, MeshProxy* const &in);
void meshFromScriptValue(const QScriptValue& value, MeshProxy* &out);


#endif // hifi_ModelScriptingInterface_h
